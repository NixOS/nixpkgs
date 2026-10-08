{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchPypi,
  k5test,
  krb5-c, # C krb5 library
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "krb5";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-j0cRoKsR7kP9pWc3HvbZSHr9vU8VbKCT6Pswb0zGha4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython == 3.3.0" "Cython"
  '';

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ krb5-c ];

  nativeCheckInputs = [
    k5test
    pytestCheckHook
  ];

  pythonImportsCheck = [ "krb5" ];

  meta = {
    description = "Kerberos API bindings for Python";
    homepage = "https://github.com/jborean93/pykrb5";
    changelog = "https://github.com/jborean93/pykrb5/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
    broken = stdenv.hostPlatform.isDarwin; # TODO: figure out how to build on Darwin
  };
})
