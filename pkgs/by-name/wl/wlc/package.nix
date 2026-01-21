{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "wlc";
  version = "1.17.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9BM2xNbiNy8efpkZjEhQ2OSl0RJiOGSut16o8yMA14A=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    argcomplete
    python-dateutil
    requests
    pyxdg
    responses
    twine
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wlc" ];

  meta = {
    description = "Weblate commandline client using Weblate's REST API";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "wlc";
  };
}
