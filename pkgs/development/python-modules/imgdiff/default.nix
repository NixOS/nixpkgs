{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  mock,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "imgdiff";
  version = "1.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "imgdiff";
    rev = version;
    hash = "sha256-Y5nUnjihRpVVehhP1LUgfuJN5nCxEJu6P1w99Igpxjs=";
  };

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "imgdiff" ];

  nativeCheckInputs = [
    mock
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Compare two images side-by-side";
    mainProgram = "imgdiff";
    homepage = "https://github.com/mgedmin/imgdiff";
    changelog = "https://github.com/mgedmin/imgdiff/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}
