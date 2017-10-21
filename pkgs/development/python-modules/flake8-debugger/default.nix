{ lib, fetchurl, buildPythonPackage, flake8, nose }:

buildPythonPackage rec {
  pname = "flake8-debugger";
  name = "${pname}-${version}";
  version = "1.4.0";
  src = fetchurl {
    url = "mirror://pypi/f/flake8-debugger/${name}.tar.gz";
    sha256 = "0chjfa6wvnqjnx778qzahhwvjx1j0rc8ax0ipp5bn70gf47lj62r";
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
