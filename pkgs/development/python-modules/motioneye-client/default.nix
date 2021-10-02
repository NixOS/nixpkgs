{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-timeout
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motioneye-client";
  version = "0.3.11";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f34ig8njyn7dzy8272m0b1nlnnhir58ar3vx4zps10i0dc32hb2";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-aiohttp
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov-report=html:htmlcov --cov-report=xml:coverage.xml --cov-report=term-missing --cov=motioneye_client --cov-fail-under=100" ""
  '';

  pythonImportsCheck = [ "motioneye_client" ];

  meta = with lib; {
    description = "Python library for motionEye";
    homepage = "https://github.com/dermotduffy/motioneye-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
