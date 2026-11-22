{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ephem";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brandon-rhodes";
    repo = "pyephem";
    tag = finalAttrs.version;
    hash = "sha256-oUeVpUX9Tcv6fSQku29mgVx0Je2X6TgIzHO8iuM5i+o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The unpacked sources shadow the installed extension module.
  preCheck = ''
    rm -r ephem
  '';

  pytestFlags = [
    "--pyargs"
    "ephem.tests"
  ];

  disabledTests = [
    # unittest.load_tests() attaches the JPL ephemeris path. Pytest collects
    # the bare JPLTest class, which has no path.
    "JPLTest"
  ];

  pythonImportsCheck = [ "ephem" ];

  meta = {
    description = "Scientific-grade astronomy routines for Python";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    changelog = "https://github.com/brandon-rhodes/pyephem/blob/${finalAttrs.src.tag}/ephem/doc/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
  };
})
