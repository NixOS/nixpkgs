{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  oelint-parser,
}:

buildPythonPackage (finalAttrs: {
  pname = "oelint-data";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-data";
    tag = finalAttrs.version;
    hash = "sha256-TN37FfLPBRrVZ8BKqp7If9EBK8JkyUAdwztHjIJX2Bc=";
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
