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
  version = "2.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpadilla";
    repo = "pyjwt";
    rev = "refs/tags/${version}";
    hash = "sha256-BPVythRLpglYtpLEoaC7+Q4l9izYXH2M9JEbxdyQZqU=";
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

  nativeCheckInputs = [ pytestCheckHook ] ++ (lib.flatten (lib.attrValues optional-dependencies));

  disabledTests = [
    # requires internet connection
    "test_get_jwt_set_sslcontext_default"
  ];

  pythonImportsCheck = [ "jwt" ];

  passthru.tests = {
    inherit oauthlib;
  };

  meta = with lib; {
    changelog = "https://github.com/jpadilla/pyjwt/blob/${version}/CHANGELOG.rst";
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
