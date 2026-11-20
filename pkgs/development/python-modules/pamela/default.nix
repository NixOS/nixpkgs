{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pkgs,

  # build-system
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pamela";
  version = "1.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-DqbiqZ3e2Md4OkoG8tMfW9ytiU15EB6PCTIuOHo0qs8=";
  };

  postPatch = ''
    substituteInPlace pamela.py \
      --replace-fail \
        'find_library("pam")' \
        '"${lib.getLib pkgs.pam}/lib/libpam${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "PAM interface using ctypes";
    homepage = "https://github.com/minrk/pamela";
    license = lib.licenses.mit;
  };
})
