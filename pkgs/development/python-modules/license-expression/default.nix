{ lib, buildPythonPackage, fetchFromGitHub
, boolean-py
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "v${version}";
    sha256 = "15dk3j5sr8iypzqqa8wa12b2a84f6ssbfvam1c1vzz00y2y5v3ic";
  };
  postPatch = "patchShebangs ./configure";

  propagatedBuildInputs = [ boolean-py ];

  meta = with lib; {
    homepage = "https://github.com/nexB/license-expression";
    description = "Utility library to parse, normalize and compare License expressions for Python using a boolean logic engine";
    license = licenses.asl20;
  };

}
