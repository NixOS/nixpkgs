{
  lib,
  callPackage,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  replaceVars,
  hatchling,
}:

buildPythonPackage rec {
  pname = "attrs";
<<<<<<< HEAD
  version = "25.4.0";
=======
  version = "25.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-FtWWm4fwhZ7zOkizXVWsG+bkKuSdXoU7WX23DDXFfhE=";
=======
    hash = "sha256-ddfO/H+1dnR7LIG0RC1NShzgkAlzUnwBHRAw/Tv0rxs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    cp -R tests $testout
=======
    cp -R conftest.py tests $testout
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  pythonImportsCheck = [ "attr" ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

<<<<<<< HEAD
  meta = {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/python-attrs/attrs";
    changelog = "https://github.com/python-attrs/attrs/releases/tag/${version}";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/python-attrs/attrs";
    changelog = "https://github.com/python-attrs/attrs/releases/tag/${version}";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
