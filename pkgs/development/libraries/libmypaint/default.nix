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
  version = "1.5.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "libmypaint";
    rev = "v${version}";
    sha256 = "06szsadj589vlvn33gzybygdknsaahr4cpigh2xyg8mr3h9ngqrl";
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

  postPatch = ''
    sed 's|python2|python|' -i autogen.sh
  '';

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = http://mypaint.org/;
    description = "Library for making brushstrokes which is used by MyPaint and other projects";
    license = licenses.isc;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
