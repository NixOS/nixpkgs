{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "wlc";
  version = "1.16.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gTVt5cxz8tk63mnTZAtzcYdy4m0NVR0y6xjmVICw7pg=";
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

<<<<<<< HEAD
  meta = {
    description = "Weblate commandline client using Weblate's REST API";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
=======
  meta = with lib; {
    description = "Weblate commandline client using Weblate's REST API";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ paperdigits ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "wlc";
  };
}
