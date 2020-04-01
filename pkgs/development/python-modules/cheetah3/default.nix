{ lib, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "cheetah3";
  version = "3.2.4";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/4e/72/e6a7d92279e3551db1b68fd336fd7a6e3d2f2ec742bf486486e6150d77d2/Cheetah3-3.2.4.tar.gz";
    sha256 = "caabb9c22961a3413ac85cd1e5525ec9ca80daeba6555f4f60802b6c256e252b";
  };

  doCheck = false; # Circular dependency

  meta = {
    homepage = http://www.cheetahtemplate.org/;
    description = "A template engine and code generation tool";
    license = lib.licenses.mit;
  };
}
