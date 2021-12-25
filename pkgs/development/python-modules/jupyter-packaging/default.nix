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
  version = "0.11.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jupyter_packaging";
    inherit version;
    sha256 = "6f5c7eeea98f7f3c8fb41d565a94bf59791768a93f93148b3c2dfb7ebade8eec";
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
