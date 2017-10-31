{ lib
, fetchurl
, buildPythonPackage
, pytest
, isPy3k
, psutil
}:

let
  pname = "multidict";
  version = "3.3.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "e76909da2fad6966281d4e0e4ccfd3c3025699ebcc30806afa09fa1384c3532b";
  };

  checkInputs = [ pytest psutil ];

  checkPhase = ''
    py.test
  '';

  disabled = !isPy3k;

  meta = {
    description = "Multidict implementation";
    homepage = https://github.com/aio-libs/multidict/;
    license = lib.licenses.asl20;
  };
}