{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aiostream";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-w5FVXksR3k9uKQ4fZIbR7KRf38bD9nj6wGrhue/7Nus=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov aiostream --cov-report html --cov-report term" ""
  '';

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiostream"
  ];

  meta = with lib; {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    changelog = "https://github.com/vxgmichel/aiostream/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
