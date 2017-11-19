{ requireFile, stdenv, unzip }:

stdenv.mkDerivation rec {
  version = "10.2";
  name = "amdadl-sdk-${version}";

  src = requireFile {
    name = "ADL_SDK_V10.2.zip";
    url = http://developer.amd.com/tools-and-sdks/graphics-development/display-library-adl-sdk/;
    sha256 = "6f6de218cff77fc14616332ef63d355d60d14849b37f8f10e1a9f4edf36c8017";
  };

  buildInputs = [ unzip ];

  doCheck = false;

  unpackPhase = ''
    unzip $src
  '';

  patchPhase = ''
    sed -i -e '/include/a \#include <wchar.h>' include/adl_structures.h || die
  '';

  buildPhase = ''
    #Build adlutil
    cd adlutil
    g++ -fpermissive main.c -o adlutil -DLINUX -ldl -I ../include/
    cd ..
  '';

  installPhase = ''
    #Install SDK
    mkdir -p $out/bin
    cp -r include "$out/"
    cp "adlutil/adlutil" "$out/bin/adlutil"

    #Fix modes
    chmod -R 755 "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "API to access display driver functionality for ATI graphics cards";
    homepage = http://developer.amd.com/tools/graphics-development/display-library-adl-sdk/;
    license = licenses.unfree;
    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
