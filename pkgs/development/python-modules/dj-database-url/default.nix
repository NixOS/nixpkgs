{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "0.5.0";

  src = fetchFromGitHub {
     owner = "kennethreitz";
     repo = "dj-database-url";
     rev = "v0.5.0";
     sha256 = "00rl0qyhmb5rrz2b8illxrxd707fzf2h9cx2x69d83p1xyw6890y";
  };

  # Tests access a DB via network
  doCheck = false;

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/kennethreitz/dj-database-url";
    license = licenses.bsd2;
  };
}
