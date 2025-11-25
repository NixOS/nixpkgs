{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "mypaint-brushes";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint-brushes";
    rev = "v${version}";
    sha256 = "1c95l1vfz7sbrdlzrbz7h1p6s1k113kyjfd9wfnxlm0p6562cz3j";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  # don't rely on rigid autotools versions, instead preload whatever is in $PATH in the build environment.
  # mypaint-brushes1 1.3.1 only officially supports autotools up to 1.16,
  # unstable git versions support up to autotools 1.17.
  # However, we are now on autotools 1.18, so this would break.
  preConfigure = ''
    export AUTOMAKE=automake
    export ACLOCAL=aclocal
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "http://mypaint.org/";
    description = "Brushes used by MyPaint and other software using libmypaint";
    license = licenses.cc0;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
