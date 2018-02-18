{ lib, fetchurl, buildPythonPackage, flake8, nose }:

buildPythonPackage rec {
  pname = "flake8-debugger";
  name = "${pname}-${version}";
  version = "3.1.0";
  src = fetchurl {
    url = "mirror://pypi/f/flake8-debugger/${name}.tar.gz";
    sha256 = "be4fb88de3ee8f6dd5053a2d347e2c0a2b54bab6733a2280bb20ebd3c4ca1d97";
  };
  buildInputs = [ nose ];
  propagatedBuildInputs = [ flake8 ];
  meta = {
    homepage = https://github.com/jbkahn/flake8-debugger;
    description = "ipdb/pdb statement checker plugin for flake8";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
