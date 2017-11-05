{ lib
, fetchurl
, buildPythonPackage
, cython
, pytest, psutil, pytestrunner
, isPy3k
}:

let
  pname = "multidict";
  version = "3.3.2";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "f82e61c7408ed0dce1862100db55595481911f159d6ddec0b375d35b6449509b";
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
