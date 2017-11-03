{ stdenv, buildPythonPackage, isPy27, isPyPy, fetchPypi, libffi, pycparser, pytest }:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.11.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6";
  };

  patches = stdenv.lib.optional (isPy27 && stdenv.cc.isClang) ./clang.patch;

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ libffi pycparser ];
  buildInputs = [ pytest ];

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = stdenv.lib.optionals stdenv.cc.isClang [ "-Wno-unused-command-line-argument" "-Wno-unreachable-code" ];

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
