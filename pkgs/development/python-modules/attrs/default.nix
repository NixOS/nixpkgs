{ lib
, callPackage
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "22.2.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ySJ7/C8BmTwD9o2zfR0VyWkBiDI8BnxkHxo1ylgYX5k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R conftest.py tests $testout
  '';

  pythonImportsCheck = [
    "attr"
  ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/python-attrs/attrs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
