{ lib, stdenv, fetchurl, unzip, cmake }:
let
  s = # Generated upstream information
  rec {
    baseName="angelscript";
    version = "2.35.0";
    name="${baseName}-${version}";
    url="http://www.angelcode.com/angelscript/sdk/files/angelscript_${version}.zip";
    sha256 = "sha256-AQ3UXiPnNNRvWJHXDiaGB6EsuasSUD3aQvhC2dt+iFc=";
  };

in
stdenv.mkDerivation {
  inherit (s) name version;

  src = fetchurl {
    inherit (s) url sha256;
  };

  nativeBuildInputs = [ unzip cmake ];

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
    inherit (s) version;
    description = "Light-weight scripting library";
    license = licenses.zlib;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    downloadPage = "https://www.angelcode.com/angelscript/downloads.html";
    homepage = "https://www.angelcode.com/angelscript/";
  };
}
