{ lib
, buildPythonPackage
, fetchPypi
, cmake
, pybind11
, numpy
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qdldl";
  version = "0.1.7.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eY2IwW4CU2rmXHHwa2Tj+/MbdNfke8EP+YFnaGMrOmQ=";
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
    description = "A free LDL factorization routine";
    homepage = "https://github.com/oxfordcontrol/qdldl";
    downloadPage = "https://github.com/oxfordcontrol/qdldl-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
