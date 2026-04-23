{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  callPackage,

  setuptools,

  attrs,
  frozendict,
  google-auth,
  mock,
  pillow,
  protobuf,
  pytz,
  requests,
  ruamel-yaml,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "appengine-python-standard";
  version = "1.1.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "appengine-python-standard";
    tag = "v${version}";
    hash = "sha256-XsqBhuSKm0OvvhT/BNWo4ca5FKrVVIsSVsHaXHNn16s=";
  };

  build-system = [
    setuptools
  ];

  dependencies =
    let
      urllib3_v1 = urllib3.overridePythonAttrs (old: rec {
        version = "1.26.20";
        src = fetchPypi {
          pname = "urllib3";
          inherit version;
          hash = "sha256-QMLcDGgeR+uPkOfie/b/ffLmd0If1GdW2hFhw5ynDTI=";
        };
      });
    in
    [
      attrs
      frozendict
      google-auth
      mock
      pillow
      protobuf
      pytz
      requests
      ruamel-yaml
      six
      urllib3_v1
    ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "appengine-python-standard" ];

  meta = {
    homepage = "https://github.com/GoogleCloudPlatform/appengine-python-standard";
    description = "Google App Engine services SDK for Python 3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ollyfg ];
  };
}
