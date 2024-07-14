{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,

  # propagates
  click,
  jinja2,
  shellingham,
  six,
}:

buildPythonPackage rec {
  pname = "click-completion";
  version = "0.5.2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W/gWuBNn5jihkLbpG1B3kAfRQwGz+fMUXWjjyt57zoY=";
  };

  propagatedBuildInputs = [
    click
    jinja2
    shellingham
    six
  ];

  pythonImportsCheck = [ "click_completion" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = "https://github.com/click-contrib/click-completion";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
