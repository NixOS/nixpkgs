{ lib, buildPythonPackage, setuptools, cmake, zlib, fetchPypi, cffi }:
buildPythonPackage rec {
  pname = "pylibfst";
  version = "0.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/aAEfGuuJgEKQuXgdH67P3mo7wjFBWNRksl0Up0ylSU=";
  };
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    setuptools
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    cffi
  ];

  meta = with lib; {
    homepage = "https://github.com/mschlaegl/pylibfst";
    description = "Handle Fast Signal Traces (fst) in Python";
    maintainers = with maintainers; [ avimitin ];
    license = licenses.bsd3;
  };
}
