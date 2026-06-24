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
  version = "0.2.4a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "bubop";
    tag = "v${version}";
    hash = "sha256-KHK84jDNPqp7lHs35Vo4jidNb5fqI3FVglGUHb2jq2g=";
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
