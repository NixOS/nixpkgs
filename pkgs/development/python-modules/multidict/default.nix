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
    sha256 = "b72486b3ad2b8444f7afebdafda8b111c1803e37203dfe81b7765298f2781778";
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
