{ lib
, fetchurl
, buildPythonPackage
, cython
, pytest, psutil, pytestrunner
, isPy3k
}:

let
  pname = "multidict";
  version = "4.0.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
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
