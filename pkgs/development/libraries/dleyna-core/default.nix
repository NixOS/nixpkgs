{ stdenv, autoreconfHook, pkgconfig, fetchFromGitHub, gupnp }:

stdenv.mkDerivation rec {
  pname = "dleyna-core";
  name = "${pname}-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "01org";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x5vj5zfk95avyg6g3nf6gar250cfrgla2ixj2ifn8pcick2d9vq";
  };

  setupHook = ./setup-hook.sh;

  patches = [ ./0001-Search-connectors-in-DLEYNA_CONNECTOR_PATH.patch ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ gupnp ];

  meta = with stdenv.lib; {
    description = "Library of utility functions that are used by the higher level dLeyna";
    homepage = https://01.org/dleyna;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
