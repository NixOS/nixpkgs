{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, prompt-toolkit
, pycryptodome
, pydantic
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pykoplenti";
  version = "1.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stegm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2sGkHCIGo1lzLurvQBmq+16sodAaK8v+mAbIH/Gd3+E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    # remove with 1.1.0
    substituteInPlace setup.cfg \
      --replace 'version = unreleased' 'version = ${version}'
  '';

  propagatedBuildInputs = [
    aiohttp
    pycryptodome
    pydantic
  ];

  passthru.optional-dependencies = {
    CLI = [
      click
      prompt-toolkit
    ];
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykoplenti" ];

  meta = with lib; {
    description = "Python REST client API for Kostal Plenticore Inverters";
    homepage = "https://github.com/stegm/pykoplenti/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
