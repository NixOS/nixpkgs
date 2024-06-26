{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "angelscript";
  version = "2.36.1";

  src = fetchurl {
    url = "https://www.angelcode.com/angelscript/sdk/files/angelscript_${version}.zip";
    sha256 = "sha256-WLt0mvnH44YwRwX05uYnrkHf4D4LanPD0NLgF8T8lI8=";
  };

  nativeBuildInputs = [
    unzip
    cmake
  ];

  preConfigure = ''
    export ROOT=$PWD
    cd angelscript/projects/cmake
  '';

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  postInstall = ''
    mkdir -p "$out/share/docs/angelscript"
    cp -r $ROOT/docs/* "$out/share/docs/angelscript"
  '';

  meta = with lib; {
    description = "Light-weight scripting library";
    license = licenses.zlib;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    downloadPage = "https://www.angelcode.com/angelscript/downloads.html";
    homepage = "https://www.angelcode.com/angelscript/";
  };
}
