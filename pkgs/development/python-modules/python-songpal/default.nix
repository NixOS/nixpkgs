{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, async-upnp-client
, attrs
, click
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "python-songpal";
  version = "0.15.2";

  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rytilahti";
    repo = "python-songpal";
    rev = "refs/tags/release/${version}";
    hash = "sha256-bAlMOxX4rx4URk+xvlte7l005i3H0VDaH67AWMdhTeY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-upnp-client
    attrs
    click
    importlib-metadata
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "songpal" ];

  meta = with lib; {
    description = "Python library for interfacing with Sony's Songpal devices";
    homepage = "https://github.com/rytilahti/python-songpal";
    changelog = "https://github.com/rytilahti/python-songpal/blob/release/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
