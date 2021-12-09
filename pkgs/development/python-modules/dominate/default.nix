{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.6.0";

  src = fetchFromGitHub {
     owner = "Knio";
     repo = "dominate";
     rev = "2.6.0";
     sha256 = "0i9lf7mz5y91xfga6dycj7d4z57f4cdyrhar38qxg9kzwci1xx5n";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = "https://github.com/Knio/dominate/";
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
