{ stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkgconfig
, gupnp
}:

stdenv.mkDerivation rec {
  pname = "dleyna-core";
  version = "0.6.0";

  setupHook = ./setup-hook.sh;

  src = fetchFromGitHub {
    owner = "01org";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x5vj5zfk95avyg6g3nf6gar250cfrgla2ixj2ifn8pcick2d9vq";
  };

  patches = [
    ./0001-Search-connectors-in-DLEYNA_CONNECTOR_PATH.patch

    # fix build with gupnp 1.2
    # https://github.com/intel/dleyna-core/pull/52
    (fetchpatch {
      url = https://github.com/intel/dleyna-core/commit/41b2e56f67b6fc9c8c256b86957d281644b9b846.patch;
      sha256 = "1h758cp65v7qyfpvyqdri7q0gwx85mhdpkb2y8waq735q5q9ib39";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  propagatedBuildInputs = [
    gupnp
  ];

  meta = with stdenv.lib; {
    description = "Library of utility functions that are used by the higher level dLeyna";
    homepage = https://01.org/dleyna;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
