{ stdenv, buildPythonPackage, isPyPy, fetchPypi, libffi, pycparser, pytest }:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.10.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mffyilq4qycm8gs4wkgb18rnqil8a9blqq77chdlshzxc8jkc5k";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ libffi pycparser ];
  buildInputs = [ pytest ];

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = stdenv.lib.optional stdenv.cc.isClang "-Wno-unreachable-code";

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar ];
    homepage = https://cffi.readthedocs.org/;
    license = with licenses; [ mit ];
    description = "Foreign Function Interface for Python calling C code";
  };
}
