{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiovlc";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZFLNgPxR5N+hI988POCYJD9QGivs1fYysyFtmxsJQaA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      " --cov=aiovlc --cov-report=term-missing:skip-covered" ""
  '';

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiovlc"
  ];

  meta = with lib; {
    description = "Python module to control VLC";
    homepage = "https://github.com/MartinHjelmare/aiovlc";
    changelog = "https://github.com/MartinHjelmare/aiovlc/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
