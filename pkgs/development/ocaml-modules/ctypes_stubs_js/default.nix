{ lib, fetchFromGitLab, buildDunePackage, integers_stubs_js, ctypes, ppx_expect, ocaml }:

buildDunePackage rec {
  pname = "ctypes_stubs_js";
  version = "0.1";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = version;
    sha256 = "sha256-OJIzg2hnwkXkQHd4bRR051eLf4HNWa/XExxbj46SyUs=";
  };

  propagatedBuildInputs = [ integers_stubs_js ];

  checkInputs = [ ctypes ppx_expect ];

  meta = with lib; {
    homepage = "https://gitlab.com/nomadic-labs/ctypes_stubs_js";
    description = "js_of_ocaml stubs for the OCaml integers library";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
    inherit (ocaml.meta) platforms;
  };
}
