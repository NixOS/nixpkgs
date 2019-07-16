{ stdenv, fetchFromGitHub, pkg-config, sqlite, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "proj";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "0w2v2l22kv0xzq5hwl7n8ki6an8vfsr0lg0cdbkwcl4xv889ysma";
  };

  outputs = [ "out" "dev"];

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ sqlite ];

  doCheck = stdenv.is64bit;

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = https://proj4.org;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
