{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hijridate";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dralshehri";
    repo = "hijridate";
    tag = "v${version}";
    hash = "sha256-IT5OnFDuNQ9tMfuZ5pFqnAPd7nspIfAmeN6Pqtn0OwA=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hijridate" ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijridate";
    changelog = "https://github.com/dralshehri/hijridate/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
