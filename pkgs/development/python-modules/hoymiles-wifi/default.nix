{
  pkgs,
  lib,
}:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "hoymiles-wifi";
  version = "0.5.5";

  src = pkgs.fetchFromGitHub {
    owner = "suaveolent";
    repo = "hoymiles-wifi";
    rev = "v" + version;
    hash = "sha256-lI6uEAXhzxQMz2jZ9oDLTnICOc0+ECbWK2MNuK/aUOw=";
  };

  pyproject = true;

  build-system = [ pkgs.python3Packages.setuptools ];

  propagatedBuildInputs = [
    pkgs.python3Packages.protobuf
    pkgs.python3Packages.crcmod
    pkgs.python3Packages.cryptography
  ];

  doCheck = false;

  pythonImportsCheck = [ "hoymiles_wifi" ];

  meta = {
    description = "Library to communicate with Hoymiles DTUs and HMS WiFi enabled microinverters via protobuf";
    homepage = "https://github.com/suaveolent/hoymiles-wifi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.maximumstock ];
  };
}
