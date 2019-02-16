{ stdenv, fetchurl, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.6";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/l/llfuse/${name}.tar.bz2";
    sha256 = "31a267f7ec542b0cd62e0f1268e1880fdabf3f418ec9447def99acfa6eff2ec9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse ];
  checkInputs = [ pytest attr which ];

  propagatedBuildInputs = [ contextlib2 ];

  checkPhase = ''
    py.test -k "not test_listdir"
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = https://code.google.com/p/python-llfuse/;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
