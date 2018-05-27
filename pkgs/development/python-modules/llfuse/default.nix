{ stdenv, fetchurl, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.4";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/l/llfuse/${name}.tar.bz2";
    sha256 = "50396c5f3c49c3145e696e5b62df4fcca8b66634788020fba7b6932a858c78c2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pytest fuse attr which ];

  propagatedBuildInputs = [ contextlib2 ];

  checkPhase = ''
    py.test
  '';

  # FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = https://code.google.com/p/python-llfuse/;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
