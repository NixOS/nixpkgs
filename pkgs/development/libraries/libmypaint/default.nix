{ stdenv
, autoconf
, automake
, fetchFromGitHub
, glib
, intltool
, json_c
, libtool
, pkgconfig
, python3
}:

stdenv.mkDerivation rec {
  pname = "libmypaint";
  version = "1.6.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "libmypaint";
    rev = "v${version}";
    sha256 = "1ppgpmnhph9h8ayx9776f79a0bxbdszfw9c6bw7c3ffy2yk40178";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    pkgconfig
    python3
  ];

  buildInputs = [
    glib
  ];

  # for libmypaint.pc
  propagatedBuildInputs = [
    json_c
  ];

  doCheck = true;

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "http://mypaint.org/";
    description = "Library for making brushstrokes which is used by MyPaint and other projects";
    license = licenses.isc;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
