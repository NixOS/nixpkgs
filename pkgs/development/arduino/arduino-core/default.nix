{ stdenv, lib, fetchFromGitHub, fetchurl, jdk, ant
, libusb, libusb1, unzip, zlib, ncurses, readline
, withGui ? false, gtk2 ? null
}:

assert withGui -> gtk2 != null;

let
  externalDownloads = import ./downloads.nix {inherit fetchurl; inherit (lib) optionalAttrs; inherit (stdenv) system;};
  # Some .so-files are later copied from .jar-s to $HOME, so patch them beforehand
  patchelfInJars =
       lib.optional (stdenv.system == "x86_64-linux") {jar = "share/arduino/lib/jssc-2.8.0.jar"; file = "libs/linux/libjSSC-2.8_x86_64.so";}
    ++ lib.optional (stdenv.system == "i686-linux") {jar = "share/arduino/lib/jssc-2.8.0.jar"; file = "libs/linux/libjSSC-2.8_x86.so";}
  ;
  # abiVersion 6 is default, but we need 5 for `avrdude_bin` executable
  ncurses5 = ncurses.override { abiVersion = "5"; };
in
stdenv.mkDerivation rec {
  version = "1.6.9";
  name = "arduino${stdenv.lib.optionalString (withGui == false) "-core"}-${version}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "0ksd6mkcf41114n0h37q80y1bz3a2q3z8kg6m9i11c3wrj8n80np";
  };

  buildInputs = [ jdk ant libusb libusb1 unzip zlib ncurses5 readline ];
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

    # Loop above creates library_index.json.gz, package_index.json.gz and package_index.json.sig in
    # current directory. And now we can inject them into build process.
    library_index_url=file://$(pwd)/library_index.json
    package_index_url=file://$(pwd)/package_index.json

    cd ./arduino-core && ant
    cd ../build && ant -Dlibrary_index_url=$library_index_url -Dpackage_index_url=$package_index_url
    cd ..
  '';

  # This will be patched into `arduino` wrapper script
  # Java loads gtk dynamically, so we need to provide it using LD_LIBRARY_PATH
  dynamicLibraryPath = lib.makeLibraryPath [gtk2];
  javaPath = lib.makeBinPath [jdk];

  # Everything else will be patched into rpath
  rpath = (lib.makeLibraryPath [zlib libusb libusb1 readline ncurses5 stdenv.cc.cc]);

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/" #*/
    echo ${version} > $out/share/arduino/lib/version.txt

    ${stdenv.lib.optionalString withGui ''
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
        ({jar, file}:
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
    ln -s ${lib.makeLibraryPath [ncurses5]}/libncursesw.so.5 $out/lib/libtinfo.so.5
  '';

  meta = with stdenv.lib; {
    description = "Open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ antono robberer bjornfor ];
  };
}
