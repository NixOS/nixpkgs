{ stdenv, fetchFromGitHub, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2, osxfuse, cython
}:

let
  inherit (stdenv.lib) optionals optionalString;
in

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.8-2020-12-04";  # recent fixes to support pytest >6.0

  src = fetchFromGitHub {
    owner = "python-llfuse";
    repo = "python-llfuse";
    rev = "af24c5ba8d82b1f8a8144bbca2fad955ba1e12c8";
    sha256 = "1v3fx7vyi5nqqsidj4b2as7wjhgpc79jy1ybdgc092z6qxviv3lb";
  };

  nativeBuildInputs = [ pkgconfig cython ];
  buildInputs =
    optionals stdenv.isLinux [ fuse ]
    ++ optionals stdenv.isDarwin [ osxfuse ];
  checkInputs = [ pytest which ] ++
    optionals stdenv.isLinux [ attr ];

  propagatedBuildInputs = [ contextlib2 ];

  buildPhase = ''
    python setup.py build_cython
    python setup.py build_ext --inplace
    python setup.py bdist_wheel
  '';

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
