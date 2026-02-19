{
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "tesh";
  version = "0.3.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "OceanSprint";
    repo = "tesh";
    rev = finalAttrs.version;
    hash = "sha256-GIwg7Cv7tkLu81dmKT65c34eeVnRR5MIYfNwTE7j2Vs=";
  };

  checkInputs = [
    python3Packages.pytest
  ];

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    click
    pexpect
    distutils
  ];
})
