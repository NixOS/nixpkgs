{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-hpilo";
  version = "4.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seveas";
    repo = "python-hpilo";
    tag = version;
    hash = "sha256-O0WGJRxzT9R9abFOsXHSiv0aFOtBWQqTrfbw5rnuZbY=";
  };

  build-system = [ setuptools ];

  # Most tests requires an actual iLO to run
  doCheck = false;

  pythonImportsCheck = [ "hpilo" ];

  meta = with lib; {
    description = "Python module to access the HP iLO XML interface";
    homepage = "https://seveas.github.io/python-hpilo/";
    changelog = "https://github.com/seveas/python-hpilo/blob/${version}/CHANGES";
    license = with licenses; [
      asl20
      gpl3Plus
    ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "hpilo_cli";
  };
}
