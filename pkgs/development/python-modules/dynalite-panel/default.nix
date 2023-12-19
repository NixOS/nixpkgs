{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "dynalite-panel";
  version = "0.0.4";
  pyproject = true;

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m7nQzbxRe2qXUWAMeQlDZtc9F01DsbTzF/kI0ci3TFE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "~=" ">="
  '';

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "dynalite_panel" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Dynalite panel for Home Assistant";
    homepage = "https://github.com/ziv1234/dynalitepanel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
