{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "oyaml";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "oyaml";
    rev = "v${version}";
    sha256 = "0qkj8g87drvjqiqqmz36gyqiczdfcfv8zk96kkifzk4f9dl5f02j";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest test_oyaml.py
  '';

  meta = {
    description = "Ordered YAML: drop-in replacement for PyYAML which preserves dict ordering";
    homepage = "https://github.com/wimglenn/oyaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
