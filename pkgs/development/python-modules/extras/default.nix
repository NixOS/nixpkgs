{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "extras";
  version = "1.0.0";

  src = fetchFromGitHub {
     owner = "testing-cabal";
     repo = "extras";
     rev = "1.0.0";
     sha256 = "0a3lm96bppwa2k5v7pzjb705ix5dsx75i8dk8zgdxi2ph3wvkdi7";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "Useful extra bits for Python - things that should be in the standard library";
    homepage = "https://github.com/testing-cabal/extras";
    license = lib.licenses.mit;
  };
}
