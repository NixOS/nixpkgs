{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, jdk
, ant
, libusb-compat-0_1
, libusb1
, unzip
, zlib
, ncurses
, readline
, withGui ? false
, gtk3 ? null
, wrapGAppsHook
, withTeensyduino ? false
  /* Packages needed for Teensyduino */
, upx
, fontconfig
, xorg
, gcc
, atk
, glib
, pango
, gdk-pixbuf
, gtk2
, libpng12
, expat
, freetype
, cairo
, udev
}:

assert withGui -> gtk3 != null && wrapGAppsHook != null;
assert withTeensyduino -> withGui;
let
  externalDownloads = import ./downloads.nix {
    inherit fetchurl;
    inherit (lib) optionalAttrs;
    inherit (stdenv.hostPlatform) system;
  };
  # Some .so-files are later copied from .jar-s to $HOME, so patch them beforehand
  patchelfInJars =
    lib.optional (stdenv.hostPlatform.system == "aarch64-linux") { jar = "share/arduino/lib/jssc-2.8.0-arduino4.jar"; file = "libs/linux/libjSSC-2.8_aarch64.so"; }
    ++ lib.optional (builtins.match "armv[67]l-linux" stdenv.hostPlatform.system != null) { jar = "share/arduino/lib/jssc-2.8.0-arduino4.jar"; file = "libs/linux/libjSSC-2.8_armhf.so"; }
    ++ lib.optional (stdenv.hostPlatform.system == "x86_64-linux") { jar = "share/arduino/lib/jssc-2.8.0-arduino4.jar"; file = "libs/linux/libjSSC-2.8_x86_64.so"; }
    ++ lib.optional (stdenv.hostPlatform.system == "i686-linux") { jar = "share/arduino/lib/jssc-2.8.0-arduino4.jar"; file = "libs/linux/libjSSC-2.8_x86.so"; }
  ;
  # abiVersion 6 is default, but we need 5 for `avrdude_bin` executable
  ncurses5 = ncurses.override { abiVersion = "5"; };
  teensy_libpath = lib.makeLibraryPath [
    atk
    cairo
    expat
    fontconfig
    freetype
    gcc.cc.lib
    gdk-pixbuf
    glib
    gtk2
    libpng12
    libusb-compat-0_1
    pango
    udev
    xorg.libSM
    xorg.libX11
    xorg.libXext
    xorg.libXft
    xorg.libXinerama
    xorg.libXxf86vm
    zlib
  ];
  teensy_architecture = if stdenv.hostPlatform.isx86_32 then "linux32"
                        else if stdenv.hostPlatform.isx86_64 then "linux64"
                        else if stdenv.hostPlatform.isAarch64 then "linuxaarch64"
                        else if stdenv.hostPlatform.isAarch32 then "linuxarm"
                        else throw "${stdenv.hostPlatform.system} is not supported in teensy";

  flavor = (if withTeensyduino then "teensyduino" else "arduino")
             + lib.optionalString (!withGui) "-core";
in
stdenv.mkDerivation rec {
  version = "1.8.16";
  name = "${flavor}-${version}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = version;
    sha256 = "sha256-6d+y0Lgr+h0qYpCsa/ihvSMNuAdRMNQRuxZFpkWLDvg=";
  };

  teensyduino_version = "155";
  teensyduino_src = fetchurl {
    url = "https://www.pjrc.com/teensy/td_${teensyduino_version}/TeensyduinoInstall.${teensy_architecture}";
    sha256 = {
      linux64 = "sha256-DypCbCm4RKYgnFJRwoHyPht6dFG48YvWM4RzEDdJE6U=";
      linux32 = "sha256-MJ4xsTAZPO8BhO/VWSjBAjBVLrKM+3PNi1fiF8dsuVQ=";
      linuxarm = "sha256-x5JdYflLThohos9RTAWt4XrzvksB7VWfXTKqgXZ1d6Q=";
      linuxaarch64 = "sha256-N18nvavEMhvt2jOrdI+tsXtbWIdsj1n4aMVeaaBlcT4=";
    }.${teensy_architecture} or (throw "No arduino binaries for ${teensy_architecture}");
  };
  # Used because teensyduino requires jars be a specific size
  arduino_dist_src = fetchurl {
    url = "https://downloads.arduino.cc/arduino-${version}-${teensy_architecture}.tar.xz";
    sha256 =
      {
        linux64 = "sha256-VK+Skl2xjqPWYEEKt1CCLwBZRxoyRfYQ3/60Byen9po=";
        linux32 = "sha256-fjqV4avddmWAdFqMuUNUcDguxv3SI45m5QHFiWP8EKE=";
        linuxarm = "sha256-Br8vUN7njI7VCH+ZvUh44l8LcgW+61+Q0x2AiXxIhTM=";
        linuxaarch64 = "sha256-bOizBUUuyINg0/EqEatBq9lECT97JXxKbesCGyCA3YQ=";
      }.${teensy_architecture} or (throw "No arduino binaries for ${teensy_architecture}");
  };

  # the glib setup hook will populate GSETTINGS_SCHEMAS_PATH,
  # wrapGAppHooks (among other things) adds it to XDG_DATA_DIRS
  # so 'save as...' works:
  nativeBuildInputs = [ glib wrapGAppsHook unzip ];
  buildInputs = [
    jdk
    ant
    libusb-compat-0_1
    libusb1
    zlib
    ncurses5
    readline
  ] ++ lib.optionals withTeensyduino [ upx ];
  downloadSrcList = builtins.attrValues externalDownloads;
  downloadDstList = builtins.attrNames externalDownloads;

  buildPhase = ''
    # Copy pre-downloaded files to proper locations
    download_src=($downloadSrcList)
    download_dst=($downloadDstList)
    while [[ "''${#download_src[@]}" -ne 0 ]]; do
      file_src=''${download_src[0]}
      file_dst=''${download_dst[0]}
      mkdir -p $(dirname $file_dst)
      download_src=(''${download_src[@]:1})
      download_dst=(''${download_dst[@]:1})
      cp -v $file_src $file_dst
    done

    # Deliberately break build.xml's download statement in order to cause
    # an error if anything needed is missing from download.nix.
    substituteInPlace build/build.xml \
      --replace 'ignoreerrors="true"' 'ignoreerrors="false"'

    cd ./arduino-core && ant
    cd ../build && ant
    cd ..
  '';

  # This will be patched into `arduino` wrapper script
  # Java loads gtk dynamically, so we need to provide it using LD_LIBRARY_PATH
  dynamicLibraryPath = lib.makeLibraryPath [ gtk3 ];
  javaPath = lib.makeBinPath [ jdk ];

  # Everything else will be patched into rpath
  rpath = (lib.makeLibraryPath [ zlib libusb-compat-0_1 libusb1 readline ncurses5 stdenv.cc.cc ]);

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/"
    echo -n ${version} > $out/share/arduino/lib/version.txt

    ${lib.optionalString withGui ''
      mkdir -p $out/bin
      substituteInPlace $out/share/arduino/arduino \
        --replace "JAVA=java" "JAVA=$javaPath/java" \
        --replace "LD_LIBRARY_PATH=" "LD_LIBRARY_PATH=$dynamicLibraryPath:"
      ln -sr "$out/share/arduino/arduino" "$out/bin/arduino"

      cp -r build/shared/icons $out/share/arduino
      mkdir -p $out/share/applications
      cp build/linux/dist/desktop.template $out/share/applications/arduino.desktop
      substituteInPlace $out/share/applications/arduino.desktop \
        --replace '<BINARY_LOCATION>' "$out/bin/arduino" \
        --replace '<ICON_NAME>' "$out/share/arduino/icons/128x128/apps/arduino.png"
    ''}

    ${lib.optionalString withTeensyduino ''
      # Back up the original jars
      mv $out/share/arduino/lib/arduino-core.jar $out/share/arduino/lib/arduino-core.jar.bak
      mv $out/share/arduino/lib/pde.jar $out/share/arduino/lib/pde.jar.bak
      # Extract jars from the arduino distributable package
      mkdir arduino_dist
      cd arduino_dist
      tar xfJ ${arduino_dist_src} arduino-${version}/lib/arduino-core.jar arduino-${version}/lib/pde.jar
      cd ..
      # Replace the built jars with the official arduino jars
      mv arduino_dist/arduino-${version}/lib/{arduino-core,pde}.jar $out/share/arduino/lib/
      # Delete the directory now that the jars are copied out
      rm -r arduino_dist
      # Extract and patch the Teensyduino installer
      cp ${teensyduino_src} ./TeensyduinoInstall.${teensy_architecture}
      chmod +w ./TeensyduinoInstall.${teensy_architecture}
      upx -d ./TeensyduinoInstall.${teensy_architecture}
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          --set-rpath "${teensy_libpath}" \
          ./TeensyduinoInstall.${teensy_architecture}
      chmod +x ./TeensyduinoInstall.${teensy_architecture}
      ./TeensyduinoInstall.${teensy_architecture} --dir=$out/share/arduino
      # Check for successful installation
      [ -d $out/share/arduino/hardware/teensy ] || exit 1
      # After the install, copy the built jars back
      mv $out/share/arduino/lib/arduino-core.jar.bak $out/share/arduino/lib/arduino-core.jar
      mv $out/share/arduino/lib/pde.jar.bak $out/share/arduino/lib/pde.jar
    ''}
  '';

  # So we don't accidentally mess with firmware files
  dontStrip = true;
  dontPatchELF = true;

  preFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/lib $file || true
    done

    ${lib.concatMapStringsSep "\n"
      ({ jar, file }:
          ''
            jar xvf $out/${jar} ${file}
            patchelf --set-rpath $rpath ${file}
            jar uvf $out/${jar} ${file}
            rm -f ${file}
          ''
        )
      patchelfInJars}

    # avrdude_bin is linked against libtinfo.so.5
    mkdir $out/lib/
    ln -s ${lib.makeLibraryPath [ ncurses5 ]}/libtinfo.so.5 $out/lib/libtinfo.so.5

    ${lib.optionalString withTeensyduino ''
      # Patch the Teensy loader binary
      patchelf --debug \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          --set-rpath "${teensy_libpath}" \
          $out/share/arduino/hardware/tools/teensy{,_ports,_reboot,_restart,_serialmon}
    ''}
  '';

  meta = with lib; {
    description = "Open-source electronics prototyping platform";
    homepage = "http://arduino.cc/";
    license = if withTeensyduino then licenses.unfreeRedistributable else licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ antono auntie robberer bjornfor bergey ];
  };
}
