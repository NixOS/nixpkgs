{ lib
, fetchurl
, buildPythonPackage
, pytest
, isPy3k
}:

let
  pname = "multidict";
  version = "2.1.6";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "9ec33a1da4d2096949e29ddd66a352aae57fad6b5483087d54566a2f6345ae10";
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