{
  lib,
  astroid,
  buildPythonPackage,
  fetchPypi,
  pylint,
  pylint-plugin-utils,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylint-flask";
  version = "0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9Nl94iFr97/OB8nAixZul4/p8nJd4qUKmEWpfefjFRc=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pylint ];

  propagatedBuildInputs = [
    astroid
    pylint-plugin-utils
  ];

  # Tests require a very old version of pylint
  # also tests are only available at GitHub, with an old release tag
  doCheck = false;

  pythonImportsCheck = [ "pylint_flask" ];

  meta = with lib; {
    description = "Pylint plugin to analyze Flask applications";
    homepage = "https://github.com/jschaf/pylint-flask";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
