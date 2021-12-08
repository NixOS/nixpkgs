{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "backports_abc";
  version = "0.5";

  src = fetchFromGitHub {
     owner = "cython";
     repo = "backports_abc";
     rev = "0.5";
     sha256 = "1myg9k25p95dcng3rsn7kvc56ly3lbx4pbvfy7al5zk3mvjvzixk";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    homepage = "https://github.com/cython/backports_abc";
    license = lib.licenses.psfl;
    description = "A backport of recent additions to the 'collections.abc' module";
  };
}
