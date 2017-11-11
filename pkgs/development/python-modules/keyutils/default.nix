{ lib, buildPythonPackage, fetchurl, pkgs, pytestrunner }:

let
  pname = "keyutils";
  version = "0.5";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/k/${pname}/${name}.tar.gz";
    sha256 = "0dskys71vkn59vlsfs1ljli0qnzk7b10iv4pawxawnk2hvyjrf10";
  };

  buildInputs = [ pkgs.keyutils pytestrunner ];

  doCheck = false;

  meta = {
    description = "A set of python bindings for keyutils";
    homepage = https://github.com/sassoftware/python-keyutils;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ primeos ];
  };
}
