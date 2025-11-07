{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  oauthlib,
  python-dateutil,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joalla";
    repo = "discogs_client";
    tag = "v${version}";
    hash = "sha256-2mMBfOM5sOJsuoxrT3Ku99zDQ8wDw12zRloRLHRDRL0=";
  };

  propagatedBuildInputs = [
    requests
    oauthlib
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "discogs_client" ];

  meta = with lib; {
    description = "Unofficial Python API client for Discogs";
    homepage = "https://github.com/joalla/discogs_client";
    changelog = "https://github.com/joalla/discogs_client/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
