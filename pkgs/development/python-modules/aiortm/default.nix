{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "aiortm";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DTFynPFf0NUBieXDiMKhCNwBqx3s/xzggNmnz/IKjbU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    click
    yarl
  ];

  checkInputs = [
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
