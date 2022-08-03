{
  pkgs, stdenv, lib, fetchurl, buildDunePackage
, integers_stubs_js, ctypes, ppx_expect
}:

buildDunePackage rec {
  pname = "ctypes_stubs_js";
  version = "0.1";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://gitlab.com/nomadic-labs/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "74ab170e064bff88eaa592efc992d24fa1665c67047fc822276eae52c0f3384d";
  };

  propagatedBuildInputs = [ integers_stubs_js ];
  checkInputs = [
    ctypes
    ppx_expect
    pkgs.nodejs
  ];
  doCheck = true;

  meta = {
    description = "Js_of_ocaml Javascript stubs for the OCaml ctypes library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bezmuth ];
    homepage = "https://gitlab.com/nomadic-labs/ctypes_stubs_js";
  };
}
