{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pyudev
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec {
  pname = "monitorcontrol";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "monitorcontrol";
    rev = "refs/tags/${version}";
    hash = "sha256-fu0Lm7Tcw7TCCBDXTTY20JBAM7oeesyeHQFFILeZxX0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyudev
  ];

  nativeCheckInputs = [
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [
    pname
  ];

  meta = with lib; {
    description = "Python monitor controls using DDC-CI";
    homepage = "https://github.com/newAM/monitorcontrol";
    changelog = "https://github.com/newAM/monitorcontrol/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ newam ];
  };
}
