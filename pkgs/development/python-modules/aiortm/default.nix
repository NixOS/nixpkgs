{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, click
, fetchFromGitHub
, pydantic
, poetry-core
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "aiortm";
  version = "0.6.4";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-PFZ8B2Wtjg3xUFYcnthTW5QXLk//lFH25jwpF7hygxQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aiortm --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "aiortm"
  ];

  meta = with lib; {
    description = "Library for the Remember the Milk API";
    homepage = "https://github.com/MartinHjelmare/aiortm";
    changelog = "https://github.com/MartinHjelmare/aiortm/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
