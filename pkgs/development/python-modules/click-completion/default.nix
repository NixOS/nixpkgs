{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  # propagates
  click,
  jinja2,
  shellingham,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-completion";
  version = "0.5.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "click-completion";
    inherit (finalAttrs) version;
    hash = "sha256-W/gWuBNn5jihkLbpG1B3kAfRQwGz+fMUXWjjyt57zoY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    jinja2
    shellingham
    six
  ];

  pythonImportsCheck = [ "click_completion" ];

  # has no tests
  doCheck = false;

  meta = {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = "https://github.com/click-contrib/click-completion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mbode ];
  };
})
