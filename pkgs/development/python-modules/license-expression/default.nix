{ lib, buildPythonPackage, fetchFromGitHub
, boolean-py
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "v${version}";
    sha256 = "0bbd7d90z58p9sd01b00g0vfd9bmwzksjb7pc8833s2jpja9mxz1";
  };
  postPatch = "patchShebangs ./configure";

  propagatedBuildInputs = [ boolean-py ];

  meta = with lib; {
    homepage = "https://github.com/nexB/license-expression";
    description = "Utility library to parse, normalize and compare License expressions for Python using a boolean logic engine";
    license = licenses.asl20;
  };

}
