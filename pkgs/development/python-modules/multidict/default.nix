{ lib
, fetchurl
, buildPythonPackage
, pytest
, isPy3k
}:

let
  pname = "multidict";
  version = "2.1.5";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "20a30a474882ad174eb64873cfa7bae4604944105adf7f6847141bd7938c5ed1";
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