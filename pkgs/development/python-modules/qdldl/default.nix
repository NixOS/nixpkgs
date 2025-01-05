{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  pybind11,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qdldl";
  version = "0.1.7.post5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CxOZ4cSbW+1arI/WPvCKtwjTQMN/tCb+ABKLwfNrKG4=";
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [ pybind11 ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "qdldl" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Free LDL factorization routine";
    homepage = "https://github.com/oxfordcontrol/qdldl";
    downloadPage = "https://github.com/oxfordcontrol/qdldl-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
