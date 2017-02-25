{ lib
, fetchurl
, buildPythonPackage
, pytest
, isPy3k
}:

let
  pname = "multidict";
  version = "2.1.4";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "a77aa8c9f68846c3b5db43ff8ed2a7a884dbe845d01f55113a3fba78518c4cd7";
  };

  buildInputs = [ pytest ];

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