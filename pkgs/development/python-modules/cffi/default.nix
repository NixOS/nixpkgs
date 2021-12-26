{ lib, stdenv, buildPythonPackage, isPyPy, fetchPypi, pytestCheckHook,
  libffi, pkg-config, pycparser
}:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libffi ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ pycparser ];

  prePatch = lib.optionalString stdenv.isDarwin ''
    # Remove setup.py impurities
    substituteInPlace setup.py --replace "'-iwithsysroot/usr/include/ffi'" ""
    substituteInPlace setup.py --replace "'/usr/include/ffi'," ""
    substituteInPlace setup.py --replace '/usr/include/libffi' '${lib.getDev libffi}/include'
  '';

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-unused-command-line-argument -Wno-unreachable-code -Wno-c++11-narrowing";

  doCheck = !stdenv.hostPlatform.isMusl;

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar lnl7 ];
    homepage = "https://cffi.readthedocs.org/";
    license = licenses.mit;
    description = "Foreign Function Interface for Python calling C code";
  };
}
