{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "volatility3";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = "volatility3";
    tag = "v${version}";
    hash = "sha256-X2cTZaEUQm7bE0k2ve4vKj0k1N6zeLXfDzhWm32diVY=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    capstone
    jsonschema
    pefile
    pycryptodome
    yara-python
  ];

  preBuild = ''
    export HOME=$(mktemp -d);
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "volatility3"
  ];

  meta = with lib; {
    description = "Volatile memory extraction frameworks";
    homepage = "https://www.volatilityfoundation.org/";
    changelog = "https://github.com/volatilityfoundation/volatility3/releases/tag/v${version}";
    license = {
      # Volatility Software License 1.0
      free = false;
      url = "https://www.volatilityfoundation.org/license/vsl-v1.0";
    };
    maintainers = with maintainers; [ fab ];
  };
}
