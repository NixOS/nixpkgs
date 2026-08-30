{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  colorama,
  coverage,
  unidecode,
  lxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "green";
  version = "4.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "green";
    inherit (finalAttrs) version;
    hash = "sha256-pAZ8P5/CpkTtNfU2ZJUGQzROxGLm0uu1vXS3YpcVprE=";
  };

  patches = [ ./tests.patch ];

  postPatch = ''
    substituteInPlace green/test/test_integration.py \
      --subst-var-by green "$out/bin/green"
  '';

  build-system = [ setuptools ];

  dependencies = [
    colorama
    coverage
    unidecode
    lxml
  ];

  # let green run it's own test suite
  checkPhase = ''
    $out/bin/green -tvvv \
      green.test.test_version \
      green.test.test_cmdline
  '';

  pythonImportsCheck = [ "green" ];

  meta = {
    description = "Python test runner";
    homepage = "https://github.com/CleanCut/green";
    changelog = "https://github.com/CleanCut/green/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
