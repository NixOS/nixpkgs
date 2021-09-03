{ lib
, callPackage
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "21.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb";
  };

  outputs = [ "out" "testout" ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R tests $testout/tests
  '';

  pythonImportsCheck = [ "attr" ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/hynek/attrs";
    license = licenses.mit;
  };
}
