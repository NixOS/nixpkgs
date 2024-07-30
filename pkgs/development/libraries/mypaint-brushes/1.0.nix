{ lib, stdenv
, autoconf
, automake
, fetchFromGitHub
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "mypaint-brushes";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c95l1vfz7sbrdlzrbz7h1p6s1k113kyjfd9wfnxlm0p6562cz3j";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "http://mypaint.org/";
    description = "Brushes used by MyPaint and other software using libmypaint";
    license = licenses.cc0;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
