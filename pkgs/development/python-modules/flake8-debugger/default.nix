{ lib, fetchurl, buildPythonPackage, flake8, nose }:

buildPythonPackage rec {
  pname = "flake8-debugger";
  name = "${pname}-${version}";
  version = "3.0.0";
  src = fetchurl {
    url = "mirror://pypi/f/flake8-debugger/${name}.tar.gz";
    sha256 = "e5c8ac980d819db2f3fbb89fe0e43a2fe6c127edd6ce4984a3f7e0bbdac3d2d4";
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
