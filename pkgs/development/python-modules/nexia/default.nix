{ lib
, aioresponses
, buildPythonPackage
, orjson
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "nexia";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = version;
    sha256 = "sha256-Wb9qxJBbmac1B3wYJxFCdXiQ3LqIl3CHIZnNvZ5Jr5k=";
  };

  propagatedBuildInputs = [
    orjson
    requests
  ];

  checkInputs = [
    aioresponses
    requests-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [
    "nexia"
  ];

  meta = with lib; {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
