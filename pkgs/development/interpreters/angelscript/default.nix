{lib, stdenv, fetchurl, unzip}:
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
  nativeBuildInputs = [ unzip ];
  src = fetchurl {
    inherit (s) url sha256;
  };
  preConfigure = ''
    cd angelscript/projects/gnuc
    export makeFlags="$makeFlags PREFIX=$out"
  '';
  postInstall = ''
    mkdir -p "$out/share/docs/angelscript"
    cp -r ../../../docs/* "$out/share/docs/angelscript"
  '';
  meta = {
    inherit (s) version;
    description = "Light-weight scripting library";
    license = lib.licenses.zlib ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    downloadPage = "http://www.angelcode.com/angelscript/downloads.html";
    homepage="http://www.angelcode.com/angelscript/";
  };
}
