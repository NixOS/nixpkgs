{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, boost
, m4ri
, gd
}:

stdenv.mkDerivation rec {
  version = "1.2.7";
  pname = "brial";

  src = fetchFromGitHub {
    owner = "BRiAl";
    repo = "BRiAl";
    rev = version;
    sha256 = "1s0wmbb42sq6a5kxgzsz5srphclmfa4cvxdx2h9kzp0da2zcp3cm";
  };

  # FIXME package boost-test and enable checks
  doCheck = false;

  configureFlags = [
    "--with-boost-unit-test-framework=no"
  ];

  buildInputs = [
    boost
    m4ri
    gd
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/BRiAl/BRiAl;
    description = "Legacy version of PolyBoRi maintained by sagemath developers";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
