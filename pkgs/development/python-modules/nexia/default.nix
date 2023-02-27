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
  version = "2.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-VBK+h5K/irI0T0eUaYC1iouzMUo/lJshLTe0h5CtnAQ=";
  };

  propagatedBuildInputs = [
    orjson
    requests
  ];

  nativeCheckInputs = [
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
