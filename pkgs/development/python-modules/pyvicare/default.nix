{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests_oauthlib
, simplejson
, pkce
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyvicare";
  version = "1.0.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "somm15";
    repo = "PyViCare";
    rev = version;
    sha256 = "05dlasx18fkmh4z1w8550yrb26fmsb5bc73wr9whmkasm32gpfl1";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    requests_oauthlib
    simplejson
    pkce
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version_config=True," 'version="${version}",' \
      --replace "'setuptools-git-versioning'" " "
  '';

  pythonImportsCheck = [ "PyViCare" ];

  meta = with lib; {
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
