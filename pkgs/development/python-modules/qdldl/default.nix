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
  version = "0.1.7.post4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DBY7mvuSxLadRGOHsdQpUJRDiwQexOhRAnG2xP8fhv0=";
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
