{ stdenv, fetchurl, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.6";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/l/llfuse/${name}.tar.bz2";
    sha256 = "1j9fzxpgmb4rxxyl9jcf84zvznhgi3hnh4hg5vb0qaslxkvng8ii";
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
    homepage = https://github.com/python-llfuse/python-llfuse;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
