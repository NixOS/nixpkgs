{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "munge";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L4wVbmJPzJk/zhv+5blznxG1Bcf1gVYr1rtGYVwfNWo=";
  };

  build-system = [
    python.pkgs.hatchling
  ];

  dependencies = with python.pkgs; [
    charset-normalizer
    click
    pyyaml
    requests
    toml
    tomlkit
    urllib3
  ];

  optional-dependencies = with python.pkgs; {
    toml = [
      toml
    ];
    tomlkit = [
      tomlkit
    ];
    yaml = [
      pyyaml
    ];
  };

  pythonImportsCheck = [
    "munge"
  ];

  meta = {
    description = "Data manipulation library and client";
    homepage = "https://pypi.org/project/munge/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "munge";
  };
}
