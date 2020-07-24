{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "oyaml";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "oyaml";
    rev = "v${version}";
    sha256 = "13xjdym0p0jh9bvyjsbhi4yznlp68bamy3xi4w5wpcrzlcq6cfh9";
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
