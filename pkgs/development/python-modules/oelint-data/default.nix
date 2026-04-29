{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  oelint-parser,
}:

buildPythonPackage (finalAttrs: {
  pname = "oelint-data";
  version = "1.4.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-data";
    tag = finalAttrs.version;
    hash = "sha256-Q+h5qSCvybxO+RojDNoS6g1Bt/fLpiWVJHRiMkgPpvY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    oelint-parser
  ];

  pythonImportsCheck = [ "oelint_data" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Data for oelint-adv";
    homepage = "https://github.com/priv-kweihmann/oelint-data";
    changelog = "https://github.com/priv-kweihmann/oelint-data/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
