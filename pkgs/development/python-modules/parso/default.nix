{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "171a9ivhxwsd52h1cgsz40zgzpgzscn7yqb7sdjhy8m1lzj0wsv6";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = https://github.com/davidhalter/parso;
    license = lib.licenses.mit;
  };

}
