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
  version = "0.15.1";

  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rytilahti";
    repo = "python-songpal";
    rev = "refs/tags/release/${version}";
    hash = "sha256-FX5pDWjUhrhK5B7zEfvihN77pSNi2QltRu0xbkUdc/c=";
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
