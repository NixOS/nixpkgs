{ stdenv, fetchPypi, fetchpatch, buildPythonPackage, pkgconfig, pytest_5, fuse, attr, which
, contextlib2, osxfuse
}:

let
  inherit (stdenv.lib) optionals optionalString;
in

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g2cdhdqrb6m7655qp61pn61pwj1ql61cdzhr2jvl3w4i8877ddr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    optionals stdenv.isLinux [ fuse ]
    ++ optionals stdenv.isDarwin [ osxfuse ];
  checkInputs = [ pytest_5 which ] ++
    optionals stdenv.isLinux [ attr ];

  propagatedBuildInputs = [ contextlib2 ];

  checkPhase = ''
    py.test -k "not test_listdir" ${optionalString stdenv.isDarwin ''-m "not uses_fuse"''}
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = "https://github.com/python-llfuse/python-llfuse";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
