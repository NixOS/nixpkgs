{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "charset_normalizer";
    rev = "refs/tags/${version}";
    hash = "sha256-CfL5rlrwJs9453z+1xPUzs1B3OyjFBaU6klzY7gJCzA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=charset_normalizer --cov-report=term-missing" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "charset_normalizer"
  ];

  passthru.tests = { inherit aiohttp requests; };

  meta = with lib; {
    description = "Python module for encoding and language detection";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/Ousret/charset_normalizer/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
