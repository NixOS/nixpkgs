{ lib
, buildPythonPackage
, fetchPypi
, deprecation
, pythonOlder
, packaging
, pytestCheckHook
, tomlkit
}:

buildPythonPackage rec {
  pname = "jupyter-packaging";
  version = "0.8.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jupyter_packaging";
    inherit version;
    sha256 = "276c9f884286695f6ab57a017f4bb9dd4df4f5e232b783050d2aa55b6b9ed650";
  };

  propagatedBuildInputs = [ deprecation packaging tomlkit ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # disable tests depending on network connection
    "test_develop"
    "test_install"
    # Avoid unmainted "mocker" fixture library, and calls to dependent "build" module
    "test_build"
    "test_npm_build"
    "test_create_cmdclass"
    "test_ensure_with_skip_npm"
  ];

  pythonImportsCheck = [ "jupyter_packaging" ];

  meta = with lib; {
    description = "Jupyter Packaging Utilities";
    homepage = "https://github.com/jupyter/jupyter-packaging";
    license = licenses.bsd3;
    maintainers = [ maintainers.elohmeier ];
  };
}
