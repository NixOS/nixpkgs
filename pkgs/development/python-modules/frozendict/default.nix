{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "Marco-Sulla";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0qvh36pdcsv0w963fwb1f6zlzwngjxyy6zd3n5925cgxaqxn54gj";
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
