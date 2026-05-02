{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pytestCheckHook,
  sphinxHook,
  sphinx-rtd-theme,
  zope-interface,
  oauthlib,
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpadilla";
    repo = "pyjwt";
    tag = version;
    hash = "sha256-wgOa5JhQT82ppoad6s8gPH7tGRNbbVWmJaaDF84d+r0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
    zope-interface
  ];

  optional-dependencies.crypto = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ] ++ (lib.concatAttrValues optional-dependencies);

  disabledTests = [
    # requires internet connection
    "test_get_jwt_set_sslcontext_default"
  ];

  pythonImportsCheck = [ "jwt" ];

  passthru.tests = {
    inherit oauthlib;
  };

  meta = {
    changelog = "https://github.com/jpadilla/pyjwt/blob/${version}/CHANGELOG.rst";
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prikhi ];
  };
}
