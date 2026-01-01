{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-oauthlib,
  responses,
  six,
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "mwclient";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    tag = "v${version}";
    sha256 = "sha256-qnWVQEG1Ri0z4RYmmG/fxYrlIFFf/6PnP5Dnv0cZb5I=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    six
  ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "mwclient" ];

<<<<<<< HEAD
  meta = {
    description = "Python client library to the MediaWiki API";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Python client library to the MediaWiki API";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/mwclient/mwclient";
    maintainers = [ ];
  };
}
