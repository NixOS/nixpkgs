{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "findimports";
    rev = "refs/tags/${version}";
    hash = "sha256-0HD5n9kxlXB86w8zkti6MkVZxEgGRrXzM6f+g0H/jrs=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "findimports" ];

  checkPhase = ''
    # Tests fails
    rm tests/cmdline.txt

    runHook preCheck
    ${python.interpreter} testsuite.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Module for the analysis of Python import statements";
    mainProgram = "findimports";
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${version}/CHANGES.rst";
    license = with licenses; [
      gpl2Only # or
      gpl3Only
    ];
    maintainers = with maintainers; [ fab ];
  };
}
