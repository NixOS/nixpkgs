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
  version = "0.1.5.post3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-acCS9uH8I/t3moCmLm/N/i66BcklhgJIxNZ1T0c2k48=";
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [ pybind11 ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "qdldl" ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A free LDL factorization routine";
    homepage = "https://github.com/oxfordcontrol/qdldl";
    downloadPage = "https://github.com/oxfordcontrol/qdldl-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
