{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, click
, dateparser
, fetchFromGitHub
, fetchpatch
, marshmallow-dataclass
, poetry-core
, pyjwt
, pythonOlder
, pytest-asyncio
, pytestCheckHook
, tabulate
}:

buildPythonPackage rec {
  pname = "renault-api";
  version = "0.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "v${version}";
    sha256 = "049kh63yk0r0falqbl5akcwgzqjrkqqhf9y537rrlzc85ihf28b8";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    dateparser
    marshmallow-dataclass
    pyjwt
    tabulate
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/hacf-fr/renault-api/pull/371
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/hacf-fr/renault-api/commit/5457a612b9ff9f323e8449cbe9dbce465bd65a79.patch";
      sha256 = "0ds9m4j2qpv0nyg9p8dk9klnarl8wckwclddgnii6h47qci362yy";
    })
  ];

  pythonImportsCheck = [ "renault_api" ];

  meta = with lib; {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
