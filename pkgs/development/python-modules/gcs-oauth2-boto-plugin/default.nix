{
  lib,
  boto,
  buildPythonPackage,
  fasteners,
  fetchFromGitHub,
  freezegun,
  google-reauth,
  httplib2,
  oauth2client,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  retry-decorator,
  rsa,
  six,
}:

buildPythonPackage rec {
  pname = "gcs-oauth2-boto-plugin";
  version = "3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-slTxh2j9VhLiSyiTmJIFFakzpzH/+mgilDRxx0VqqKQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "rsa==4.7.2" "rsa" \
      --replace "version='2.7'" "version='${version}'"
  '';

  propagatedBuildInputs = [
    boto
    freezegun
    google-reauth
    httplib2
    oauth2client
    pyopenssl
    retry-decorator
    rsa
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gcs_oauth2_boto_plugin" ];

  meta = with lib; {
    description = "Auth plugin allowing use the use of OAuth 2.0 credentials for Google Cloud Storage";
    homepage = "https://github.com/GoogleCloudPlatform/gcs-oauth2-boto-plugin";
    changelog = "https://github.com/GoogleCloudPlatform/gcs-oauth2-boto-plugin/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
