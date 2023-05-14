{ lib, buildNimPackage, fetchFromGitHub, astpatternmatching }:

buildNimPackage rec {
  pname = "jsonschema";
  version = "unstable-2019-09-12";

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "jsonschema";
    rev = "7b41c03e3e1a487d5a8f6b940ca8e764dc2cbabf";
    sha256 = "1js64jqd854yjladxvnylij4rsz7212k31ks541pqrdzm6hpblbz";
  };

  propagatedBuildInputs = [ astpatternmatching ];

  meta = with lib; {
    homepage = "https://github.com/PMunch/jsonschema";
    description = "Schema validation of JSON for Nim";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
