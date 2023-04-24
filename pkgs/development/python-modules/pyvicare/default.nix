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
  version = "2.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "somm15";
    repo = "PyViCare";
    rev = version;
    hash = "sha256-OZvYl8wl8kOIOfsWVn74XFKMX/jAmtoMTIEQpAZmTeo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    requests-oauthlib
    simplejson
    pkce
  ];

  nativeCheckInputs = [
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
