{ lib, stdenv, buildPythonPackage, isPyPy, fetchPypi, libffi, pycparser, pytestCheckHook }:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.14.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libffi ];

  propagatedBuildInputs = [ pycparser ];

  prePatch = lib.optionalString stdenv.isDarwin ''
  '';

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-unused-command-line-argument -Wno-unreachable-code";

  doCheck = !stdenv.hostPlatform.isMusl && !stdenv.isDarwin; # TODO: Investigate

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar lnl7 ];
    homepage = "https://cffi.readthedocs.org/";
    license = licenses.mit;
    description = "Foreign Function Interface for Python calling C code";
  };
}
