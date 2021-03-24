{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-packaging";
  version = "0.8.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "276c9f884286695f6ab57a017f4bb9dd4df4f5e232b783050d2aa55b6b9ed650";
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
