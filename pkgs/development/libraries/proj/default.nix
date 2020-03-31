{ stdenv, fetchFromGitHub, pkg-config, sqlite, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "1ildcp57qsa01kvv2qxd05nqw5mg0wfkksiv9l138dbhp0s7rkxp";
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
