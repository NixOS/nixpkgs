{ lib
, fetchPypi
, buildPythonPackage
, cython
, pytest, psutil, pytestrunner
, isPy3k
}:

let

in buildPythonPackage rec {
  pname = "multidict";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y0pg3r9hlknny0zwg906wz81h8in6lgvnpbmzvl911bmnrqc95p";
  };

  buildInputs = [ cython ];
  checkInputs = [ pytest psutil pytestrunner ];

  disabled = !isPy3k;

  meta = {
    description = "Multidict implementation";
    homepage = https://github.com/aio-libs/multidict/;
    license = lib.licenses.asl20;
  };
}
