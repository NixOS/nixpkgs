{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  click-log,
  paho-mqtt,
  pyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "bch";
  version = "1.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-control-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/C+NbJ0RrWZ/scv/FiRBTh4h7u0xS4mHVDWQ0WwmlEY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    click-log
    paho-mqtt
    pyaml
  ];

  postPatch = ''
    substituteInPlace bch/cli.py setup.py \
      --replace-fail "@@VERSION@@" "${finalAttrs.version}"
  '';

  pythonImportsCheck = [ "bch" ];

  meta = {
    homepage = "https://github.com/hardwario/bch-control-tool";
    description = "HARDWARIO Hub Control Tool";
    mainProgram = "bch";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cynerd ];
  };
})
