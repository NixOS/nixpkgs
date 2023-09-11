{ lib
, ocaml
, fetchpatch
, fetchFromGitHub
, buildDunePackage
, base64
, bos
, core
, core_kernel
, core_unix ? null
, lwt_react
, ocamlgraph
, ppx_sexp_conv
, rresult
, sexplib
, tyxml
}:

buildDunePackage rec {
  pname = "bistro";
  version = "unstable-2022-05-07";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "d363bd2d8257babbcb6db15bd83fd6465df7c268";
    sha256 = "0g11324j1s2631zzf7zxc8s0nqd4fwvcni0kbvfpfxg96gy2wwfm";
  };

  patches = [ ./janestreet-0.16.patch ];

  propagatedBuildInputs = [
    base64
    bos
    core
    core_kernel
    core_unix
    lwt_react
    ocamlgraph
    ppx_sexp_conv
    rresult
    sexplib
    tyxml
  ];

  minimalOCamlVersion = "4.12";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
