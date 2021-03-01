{ lib, stdenv, fetchPypi, fetchpatch, buildPythonPackage, pkg-config, pytest, fuse, attr, which
, contextlib2, osxfuse
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g2cdhdqrb6m7655qp61pn61pwj1ql61cdzhr2jvl3w4i8877ddr";
  };

  patches = [
    # fix tests with pytest 6
    (fetchpatch {
      url = "https://github.com/python-llfuse/python-llfuse/commit/1ed8b280d2544eedf8bf209761bef0d2519edd17.diff";
      sha256 = "0wailfrr1i0n2m9ylwpr00jh79s7z3l36w7x19jx1x4djcz2hdps";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isLinux [ fuse ]
    ++ lib.optionals stdenv.isDarwin [ osxfuse ];

  checkInputs = [ pytest which ] ++
    lib.optionals stdenv.isLinux [ attr ];

  propagatedBuildInputs = [ contextlib2 ];

  checkPhase = ''
    py.test -k "not test_listdir" ${lib.optionalString stdenv.isDarwin ''-m "not uses_fuse"''}
  '';

  meta = with lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = "https://github.com/python-llfuse/python-llfuse";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
