{ stdenv, fetchFromGitHub, jdk, jre, ant, coreutils, gnugrep, file, libusb,
  unzip, readline, zlib, ncurses, withGui ? false, gtk2 ? null
}:

assert withGui -> gtk2 != null;

stdenv.mkDerivation rec {

  version = "1.6.7";
  name = "arduino${stdenv.lib.optionalString (withGui == false) "-core"}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "09ab5fcdr4b74ibhp4kd72msbdfvsfn10xghlcxwqyhiabpgai3m";
  };

  buildInputs = [ jdk ant file unzip ];

  buildPhase = ''
    cd ./build && ant 
    cd ..
  '';

  rpath = stdenv.lib.makeLibraryPath [
    zlib
    ncurses
    readline
    stdenv.cc.cc
  ];

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/"
    echo ${version} > $out/share/arduino/lib/version.txt

    ${stdenv.lib.optionalString withGui ''
      mkdir -p "$out/bin"
      sed -i -e "s|^JAVA=java|JAVA=${jdk}/bin/java|" "$out/share/arduino/arduino"
      sed -i -e "s|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${gtk2}/lib:|" "$out/share/arduino/arduino"
      ln -sr "$out/share/arduino/arduino" "$out/bin/arduino"

      cp -r build/shared/icons $out/share/arduino
      mkdir $out/share/applications
      sed -e "s,<BINARY_LOCATION>,$out/bin/arduino,g" \
          -e "s,<ICON_NAME>,$out/share/arduino/icons/128x128/apps/arduino.png,g" \
          "./build/linux/dist/desktop.template" > $out/share/applications/arduino.desktop
    ''}

    # Fixup "/lib64/ld-linux-x86-64.so.2" like references in ELF executables.
    echo "running patchelf on prebuilt binaries:"
    find "$out" -type f -executable | while read filepath; do
        # skip target firmware files
        if [[ "$filepath" == *.elf ]]; then
            continue;
        fi  

        if file "$filepath" | grep -q "(ELF.*executable|ELF.*shared object)"; then
            echo "Patching $filepath"
            if file "$filepath" | grep -q "ELF.*executable"; then
                patchelf --set-interpreter "$(cat "$NIX_CC"/nix-support/dynamic-linker)" "$filepath" || \
                    { echo "patchelf failed to process $filepath"; exit 1; }
            fi
            patchelf --set-rpath ${rpath} "$filepath" || \
                { echo "patchelf failed to set rpath for $filepath"; exit 1; }
            patchelf --shrink-rpath ${rpath} "$filepath" || \
                { echo "patchelf failed to shrink rpath for $filepath"; exit 1; }
        fi
    done

    # avrdude_bin explicitly requires libtinfo.so.5, but here these entry points are provided
    # by libncurses. Upstream provides the avrdude wrapper which adds 
    # share/arduino/hardware/tools/avr/lib to LD_LIBRARY_PATH. So we provide an appropriately
    # named link to libnurses there.
    ln -s ${ncurses}/lib/libncurses.so.5 $out/share/arduino/hardware/tools/avr/lib/libtinfo.so.5
    ln -s $out/share/arduino/hardware/tools/avr/lib/libtinfo.so.5 $out/share/arduino/hardware/tools/avr/lib/libtinfo.so

    # executables need libstdc++.so.6
    ln -s "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}/libstdc++.so.6" "$out/share/arduino/lib/libstdc++.so.6"
  '';

  meta = with stdenv.lib; {
    description = "Open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ antono robberer bjornfor flosse ];
  }; 
}
