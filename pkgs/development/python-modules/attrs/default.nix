{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "21.2.0";

  src = fetchFromGitHub {
     owner = "hynek";
     repo = "attrs";
     rev = "21.2.0";
     sha256 = "1bn7745ddxm4wsdzqxp1d7dvgqnzvnxjazz1g02di4nmxncxp051";
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
