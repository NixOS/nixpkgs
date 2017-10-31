{ stdenv, fetchurl, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2
}:

buildPythonPackage rec {
  name = "llfuse-1.0";

  src = fetchurl {
    url = "mirror://pypi/l/llfuse/${name}.tar.bz2";
    sha256 = "1li7q04ljrvwharw4fblcbfhvk6s0l3lnv8yqb4c22lcgbkiqlps";
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
