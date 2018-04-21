{ stdenv, fetchurl, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.3";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/l/llfuse/${name}.tar.bz2";
    sha256 = "e514fa390d143530c7395f640c6b527f4f80b03f90995c7b38ff0b2f86e11ce7";
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
