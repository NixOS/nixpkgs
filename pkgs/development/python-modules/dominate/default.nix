{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lda2a4nxxh9wp727vhn31rl5v7y9fxkscdjawg7gzj50xf76xj0";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = https://github.com/Knio/dominate/;
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
