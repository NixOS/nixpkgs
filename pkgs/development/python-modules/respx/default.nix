{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, httpcore
, httpx
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, trio
, xmltodict
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
    sha256 = "0if9sg83rznl37hsjw6pfk78jpxi421g9p21wd92jcd6073g4nbd";
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
