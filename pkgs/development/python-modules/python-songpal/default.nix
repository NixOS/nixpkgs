{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  async-upnp-client,
  attrs,
  click,
}:

buildPythonPackage rec {
  pname = "python-songpal";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rytilahti";
    repo = "python-songpal";
    tag = "release/${version}";
    hash = "sha256-PYw6xlUtBrxl+YeVO/2Njt5LYWEprzGPVNk1Mlr83HM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-upnp-client
    attrs
    click
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "songpal" ];

  meta = {
    description = "Python library for interfacing with Sony's Songpal devices";
    mainProgram = "songpal";
    homepage = "https://github.com/rytilahti/python-songpal";
    changelog = "https://github.com/rytilahti/python-songpal/blob/release/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
