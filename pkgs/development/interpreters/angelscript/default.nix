{stdenv, fetchurl, unzip}:
let
  s = # Generated upstream information
  rec {
    baseName="angelscript";
    version = "2.30.1";
    name="${baseName}-${version}";
    url="http://www.angelcode.com/angelscript/sdk/files/angelscript_${version}.zip";
    sha256 = "10ym7185h26gzmw5v6wz8zlycw8gzygv0aw87dmgjcyy7qfk74m4";
  };
  buildInputs = [
    unzip
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
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
    license = stdenv.lib.licenses.zlib ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://www.angelcode.com/angelscript/downloads.html";
    homepage="http://www.angelcode.com/angelscript/";
  };
}
