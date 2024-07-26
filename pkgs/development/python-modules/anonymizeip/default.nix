{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "anonymizeip";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelmeuli";
    repo = "anonymize-ip";
    rev = "v${version}";
    hash = "sha256-54q2R14Pdnw4FAmBufeq5NozsqC7C4W6QQPcjTSkM48=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "anonymizeip" ];

  meta = {
    description = "Python library for anonymizing IP addresses";
    homepage = "https://github.com/samuelmeuli/anonymize-ip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "anonymizeip";
  };
}
