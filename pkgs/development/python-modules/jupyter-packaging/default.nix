{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-packaging";
  version = "0.7.12";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sUAyV3GIGn33t/LRSZe2GQY/51rnVrkCWFLkNGAAu7g=";
  };

  propagatedBuildInputs = [ packaging ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # disable tests depending on network connection
  disabledTests = [ "test_develop" "test_install" ];

  pythonImportsCheck = [ "jupyter_packaging" ];

  meta = with lib; {
    description = "Jupyter Packaging Utilities";
    homepage = "https://github.com/jupyter/jupyter-packaging";
    license = licenses.bsd3;
    maintainers = [ maintainers.elohmeier ];
  };
}
