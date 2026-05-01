{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  loguru,
  python-dateutil,
  pyyaml,
  tqdm,
  click,
}:

buildPythonPackage rec {
  pname = "bubop";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "bubop";
    tag = "v${version}";
    hash = "sha256-NXA3UDOkCoj4dm3UO/X0w2Mpx4bw3yFO6oyOzsPgtrU=";
  };

  postPatch = ''
    # Those versions seems to work with `bubop`.
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    loguru
    python-dateutil
    pyyaml
    tqdm
    click
  ];

  pythonImportsCheck = [ "bubop" ];

  meta = {
    description = "Bergercookie's Useful Bits Of Python; helper libraries for Bergercookie's programs";
    homepage = "https://github.com/bergercookie/bubop";
    changelog = "https://github.com/bergercookie/bubop/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
