{ lib, buildPythonPackage, fetchFromGitHub
, boolean-py
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "0.999";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "v${version}";
    sha256 = "0q8sha38w7ajg7ar0rmbqrwv0n58l8yzyl96cqwcbvp578fn3ir0";
  };

  propagatedBuildInputs = [ boolean-py ];

  meta = with lib; {
    homepage = "https://github.com/nexB/license-expression";
    description = "Utility library to parse, normalize and compare License expressions for Python using a boolean logic engine";
    license = licenses.asl20;
  };

}
