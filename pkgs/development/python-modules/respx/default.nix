{ lib
, buildPythonPackage
, fetchFromGitHub
, httpcore
, httpx
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, trio
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    sha256 = "sha256-unGAIsslGXOUHXr0FKzC9bX6+Q3mNGZ9Z/dtjz0gkj4=";
  };

  # Coverage is under 100 % due to the excluded tests
  postPatch = ''
    substituteInPlace setup.cfg --replace "--cov-fail-under 100" ""
  '';

  propagatedBuildInputs = [ httpx ];

  checkInputs = [
    httpcore
    httpx
    pytest-asyncio
    pytest-cov
    pytestCheckHook
    trio
  ];

  disabledTests = [ "test_pass_through" ];
  pythonImportsCheck = [ "respx" ];

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
