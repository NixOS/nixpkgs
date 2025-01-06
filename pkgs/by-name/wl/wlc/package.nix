{
  lib,
  python3,
  fetchPypi,
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "wlc";
  version = "1.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0T8cMq5Mrv/Ygo6BfYho3sjFuu8dYZyUMtJc5gabuG4=";
  };

  propagatedBuildInputs = [
    argcomplete
    python-dateutil
    requests
    pyxdg
    responses
    twine
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Weblate commandline client using Weblate's REST API";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "wlc";
  };
}
