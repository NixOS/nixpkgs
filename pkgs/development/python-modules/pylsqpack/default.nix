{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "0.3.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LyB3jblW3H5LGop5ci1XpGUMRZl/tlwTUsv4XreqPOI=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

  meta = with lib; {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
