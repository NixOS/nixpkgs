{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  protobuf,
  crcmod,
  cryptography,
}:

buildPythonPackage rec {
  pname = "hoymiles-wifi";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suaveolent";
    repo = "hoymiles-wifi";
    rev = "v${version}";
    hash = "sha256-lI6uEAXhzxQMz2jZ9oDLTnICOc0+ECbWK2MNuK/aUOw=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    protobuf
    crcmod
    cryptography
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "hoymiles_wifi" ];

  meta = {
    changelog = "https://github.com/suaveolent/hoymiles-wifi/releases/tag/${src.rev}";
    description = "Library to communicate with Hoymiles DTUs and HMS WiFi enabled microinverters via protobuf";
    homepage = "https://github.com/suaveolent/hoymiles-wifi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.maximumstock ];
  };
}
