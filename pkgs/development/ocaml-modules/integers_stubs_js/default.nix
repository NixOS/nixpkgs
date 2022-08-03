{
  stdenv, lib, fetchurl, buildDunePackage
, js_of_ocaml, zarith_stubs_js
}:

buildDunePackage rec {
  pname = "integers_stubs_js";
  version = "1.0";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/o1-labs/${pname}/archive/${version}.tar.gz";
    sha256 = "01yzqppwnpzg8cyc0ixw2lc3y87l1hbwbk0siscphmx5r1w8n0yn";
  };

  propagatedBuildInputs = [ js_of_ocaml zarith_stubs_js ];
  doCheck = true;

  meta = {
    description = "Javascript stubs for the integers library in js_of_ocaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bezmuth ];
    homepage = "https://gitlab.com/nomadic-labs/ctypes_stubs_js";
  };
}
