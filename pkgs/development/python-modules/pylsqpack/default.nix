{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "0.3.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tnps4/aTfYUGgYJ3FL5zCqNhwEnjd1Lj7Z3xHn8jL/s=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

  meta = with lib; {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
