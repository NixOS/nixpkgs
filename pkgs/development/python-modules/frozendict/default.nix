{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Marco-Sulla";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0pb7xzv5377qpxvh76p0si5d809fxxymd7flqa3cwk8wyhgrr2xq";
  };

  disabled = !isPy3k;

  # frozendict does not come with tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Marco-Sulla/python-frozendict";
    description = "An immutable dictionary";
    license = licenses.mit;
  };
}
