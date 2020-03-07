{ stdenv
, autoconf
, automake
, fetchFromGitHub
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "mypaint-brushes";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kcqz13vzpy24dhmrx9hbs6s7hqb8y305vciznm15h277sabpmw9";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkgconfig
  ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "http://mypaint.org/";
    description = "Brushes used by MyPaint and other software using libmypaint.";
    license = licenses.cc0;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
