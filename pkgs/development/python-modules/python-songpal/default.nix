{
  lib,
  buildPythonPackage,
  pythonOlder,
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

  disabled = pythonOlder "3.8";

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python library for interfacing with Sony's Songpal devices";
    mainProgram = "songpal";
    homepage = "https://github.com/rytilahti/python-songpal";
    changelog = "https://github.com/rytilahti/python-songpal/blob/release/${version}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
