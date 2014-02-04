{ requireFile, stdenv, unzip }:

stdenv.mkDerivation rec {
  version = "6.0";
  name = "amdadl-sdk-${version}";

  src = requireFile {
    name = "ADL_SDK_6.0.zip";
    url = http://developer.amd.com/tools-and-sdks/graphics-development/display-library-adl-sdk/;
    sha256 = "429f4fd1edebb030d6366f4e0a877cf105e4383f7dd2ccf54e5aef8f2e4242c9";
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
    gcc main.c -o adlutil -DLINUX -ldl -I ../include/ 
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
