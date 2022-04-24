{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "angelscript";
  version = "2.22.2";
  nativeBuildInputs = [ unzip ];

  src = fetchurl {
    url = "http://www.angelcode.com/angelscript/sdk/files/angelscript_${version}.zip";
    sha256 = "sha256-gzR96GSZJNV+bei3OPqlx7aw+WBv8XRpHGh8u+go6N4=";
  };
  preConfigure = ''
    cd angelscript/projects/gnuc
    sed -i makefile -e "s@LOCAL = .*@LOCAL = $out@"
    export SHARED=1
    export VERSION="${version}"
    mkdir -p "$out/lib" "$out/bin" "$out/share" "$out/include"
  '';
  postBuild = ''
    rm ../../lib/*
  '';
  postInstall = ''
    mkdir -p "$out/share/docs/angelscript"
    cp -r ../../../docs/* "$out/share/docs/angelscript"
  '';
  meta = with lib; {
    description = "Light-weight scripting library";
    license = licenses.zlib;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
    downloadPage = "http://www.angelcode.com/angelscript/downloads.html";
    homepage = "http://www.angelcode.com/angelscript/";
  };
}
