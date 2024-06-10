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
  version = "0.1.7.post2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SxU5pewQzHV6/XFW1960AGAHythtd0yfD9w+NEFVV9M=";
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
