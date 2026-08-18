{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  six,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-configfile";
  version = "0.2.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "click-configfile";
    inherit (finalAttrs) version;
    hash = "sha256-lb7sE77pUOmPQ8gdzavvT2RAkVWepmKY+drfWTUdkNE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "install_requires=install_requires," 'install_requires=["click >= 6.6", "six >= 1.10"],'
  '';

  pythonImportsCheck = [ "click_configfile" ];

  disabledTests = [
    "test_configfile__with_unbound_section"
    "test_matches_section__with_bad_arg"
  ];

  meta = {
    description = "Add support for commands that use configuration files to Click";
    homepage = "https://github.com/click-contrib/click-configfile";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
