{
  lib,
  callPackage,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  hatchling,
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "25.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FtWWm4fwhZ7zOkizXVWsG+bkKuSdXoU7WX23DDXFfhE=";
  };

  patches = [
    (replaceVars ./remove-hatch-plugins.patch {
      # hatch-vcs and hatch-fancy-pypi-readme depend on pytest, which depends on attrs
      inherit version;
    })
  ];

  nativeBuildInputs = [ hatchling ];

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R tests $testout
  '';

  pythonImportsCheck = [ "attr" ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/python-attrs/attrs";
    changelog = "https://github.com/python-attrs/attrs/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
