{ lib
, callPackage
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "22.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ka3CZlRH5RkdDnxWj954sh+WctNEKB0MbhqwhUKbIrY=";
  };

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R tests $testout/tests
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
