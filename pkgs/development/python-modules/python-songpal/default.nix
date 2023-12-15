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
  version = "0.16";

  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rytilahti";
    repo = "python-songpal";
    rev = "refs/tags/release/${version}";
    hash = "sha256-wHyq63RG0lhzG33ssWyvzLjc7s1OqquXMN26N2MBHU8=";
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
