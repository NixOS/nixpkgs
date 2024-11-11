{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools_scm,
  wheel,
  klayout,
  aenum,
  cachetools,
  gitpython,
  loguru,
  pydantic,
  pydantic-settings,
  rectangle-packer,
  requests,
  ruamel-yaml-string,
  scipy,
  tomli,
  toolz,
  typer,
  numpy,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "kfactory";
  version = "0.21.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "kfactory";
    rev = "v${version}";
    sha256 = "sha256-VLhAJ5rOBKEO1FDCnlaseA+SmrMSoyS+BaEzjdHm59Y=";
  };

  nativeBuildInputs = [
    setuptools_scm
    tomli
    wheel
  ];

  pythonRemoveDeps = [
    "klayout"
  ];

  buildInputs = [
    klayout
  ];

  propagatedBuildInputs = [
    aenum
    cachetools
    gitpython
    loguru
    numpy
    pydantic
    pydantic-settings
    rectangle-packer
    requests
    ruamel-yaml
    ruamel-yaml-string
    scipy
    tomli
    toolz
    typer
  ];

  postInstall = ''
    ln -s "${klayout}/lib/pymod/klayout" "$out/lib/python$(python -V | sed -E 's/Python ([0-9]+\.[0-9]+).*/\1/')/site-packages/klayout"
  '';

  pythonImportsCheck = [ "kfactory" ];

  doCheck = true;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_pdk.py"
  ];

  meta = with lib; {
    description = "KLayout API implementation of gdsfactory";
    homepage = "https://github.com/gdsfactory/kfactory";
    license = licenses.mit;
    maintainers = [ ];
  };
}
