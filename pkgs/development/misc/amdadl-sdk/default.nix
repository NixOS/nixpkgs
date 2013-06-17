{ fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  version = "4.0";
  name = "amdadl-sdk-${version}";

  src = fetchurl {
    url = "http://download2-developer.amd.com/amd/GPU/zip/ADL_SDK_${version}.zip";
    sha256 = "4265ee2f265b69cc39b61e10f79741c1d799f4edb71dce14a7d88509fbec0efa";
  };

  buildInputs = [ unzip ];

  doCheck = false;

  unpackPhase = ''
    unzip $src
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
    license = licenses.amdadl;
    maintainers = [ maintainers.offline ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
