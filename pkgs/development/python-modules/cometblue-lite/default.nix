{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cometblue-lite";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "neffs";
    repo = "python-cometblue_lite";
    rev = "refs/tags/${version}";
    hash = "sha256-Cjd7PdZ2/neRr1jStDY5iJaGMJ/srnFmCea8aLNan6g=";
  };

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "cometblue_lite" ];

  meta = with lib; {
    description = "Module for Eurotronic Comet Blue thermostats";
    homepage = "https://github.com/neffs/python-cometblue_lite";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
