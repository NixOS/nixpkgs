{
  lib, fetchFromGitLab, buildDunePackage
, integers_stubs_js, ctypes, ppx_expect
, js_of_ocaml-compiler
, nodejs
}:

buildDunePackage rec {
  pname = "ctypes_stubs_js";
  version = "0.1";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = version;
    hash = "sha256-OJIzg2hnwkXkQHd4bRR051eLf4HNWa/XExxbj46SyUs=";
  };

  propagatedBuildInputs = [ integers_stubs_js ];
  nativeCheckInputs = [
    nodejs
    js_of_ocaml-compiler
  ];
  checkInputs = [
    ctypes
    ppx_expect
  ];
  doCheck = true;

  meta = {
    description = "Js_of_ocaml Javascript stubs for the OCaml ctypes library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bezmuth ];
    homepage = "https://gitlab.com/nomadic-labs/ctypes_stubs_js";
  };
}
