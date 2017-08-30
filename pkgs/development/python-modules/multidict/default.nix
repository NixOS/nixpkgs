{ lib
, fetchurl
, buildPythonPackage
, pytest
, isPy3k
}:

let
  pname = "multidict";
  version = "3.1.3";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "875f80a046e7799b40df4b015b8fc5dae91697936872a8d7362c909a02ec6d12";
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