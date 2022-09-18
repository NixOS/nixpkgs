{ lib
, buildPythonPackage
, fetchFromGitHub
, pkce
, pytestCheckHook
, pythonOlder
, requests-oauthlib
, simplejson
}:

buildPythonPackage rec {
  pname = "pyvicare";
  version = "2.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "somm15";
    repo = "PyViCare";
    rev = version;
    sha256 = "sha256-MlGohD9W1HNLz6ZPawt55127S3zPSA1tFLNs2gu7hLk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    requests-oauthlib
    simplejson
    pkce
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version_config=True," 'version="${version}",' \
      --replace "'setuptools-git-versioning<1.8.0'" ""
  '';

  pythonImportsCheck = [
    "PyViCare"
  ];

  meta = with lib; {
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
