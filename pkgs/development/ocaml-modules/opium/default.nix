{ buildDunePackage

, ppx_sexp_conv
, ppx_fields_conv

, cmdliner_1_1
, cohttp-lwt-unix
, logs
, magic-mime
, opium_kernel
, stringext

, alcotest
}:

buildDunePackage {
  pname = "opium";
  inherit (opium_kernel) version src meta minimumOCamlVersion;

  useDune2 = true;

  doCheck = true;

  buildInputs = [
    ppx_sexp_conv ppx_fields_conv
    alcotest
  ];

  propagatedBuildInputs = [
    opium_kernel cmdliner_1_1 cohttp-lwt-unix magic-mime logs stringext
  ];
}
