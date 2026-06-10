{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  python,
  setuptools,
  six,
  zope-testing,
}:

buildPythonPackage (finalAttrs: {
  pname = "manuel";
  version = "1.13.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XWMSDej6bZJ3gLaa4oqj6dFmmxCvPTJ4Xz+6EaW+iFo=";
  };

  patches = lib.optionals (lib.versionAtLeast python.version "3.11") [
    # https://github.com/benji-york/manuel/pull/32
    # Applying conditionally until upstream arrives at some general solution.
    (fetchpatch {
      name = "TextTestResult-python311.patch";
      url = "https://github.com/benji-york/manuel/commit/d9f12d03e39bb76e4bb3ba43ad51af6d3e9d45c0.diff";
      hash = "sha256-k0vBtxEixoI1INiKtc7Js3Ai00iGAcCvCFI1ZIBRPvQ=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ zope-testing ];

  meta = {
    description = "Documentation builder";
    homepage = "https://pypi.org/project/manuel/";
    license = lib.licenses.zpl20;
  };
})
