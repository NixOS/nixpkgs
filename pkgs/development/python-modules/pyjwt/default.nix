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

buildPythonPackage (finalAttrs: {
  pname = "pyjwt";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpadilla";
    repo = "pyjwt";
    tag = finalAttrs.version;
    hash = "sha256-SxJ2GQt1pfm8iAeTB2RmH2kliGeQ6whkM5nuesI1s/U=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ (lib.concatAttrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    # requires internet connection
    "test_get_jwt_set_sslcontext_default"
  ];

  pythonImportsCheck = [ "jwt" ];

  passthru.tests = {
    inherit oauthlib;
  };

  meta = {
    changelog = "https://github.com/jpadilla/pyjwt/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prikhi ];
  };
})
