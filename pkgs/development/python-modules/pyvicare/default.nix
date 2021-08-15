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
  version = "2.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "somm15";
    repo = "PyViCare";
    rev = version;
    sha256 = "sha256-qvP51HVIOcLDJKq8/hcJyXKsI2iUFwoPQQZvTKE28KU=";
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
