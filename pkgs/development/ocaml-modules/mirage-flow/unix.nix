{ buildDunePackage, fmt, logs, mirage-flow, ocaml_lwt, cstruct
, alcotest, mirage-flow-combinators }:

buildDunePackage {
  pname = "mirage-flow-unix";

  inherit (mirage-flow) version useDune2 src;

  # Make tests compatible with alcotest 1.4.0
  postPatch = ''
    substituteInPlace test/test.ml --replace 'Fmt.kstrf Alcotest.fail' 'Fmt.kstrf (fun s -> Alcotest.fail s)'
  '';

  propagatedBuildInputs = [ fmt logs mirage-flow ocaml_lwt cstruct ];

  doCheck = true;
  nativeCheckInputs = [ alcotest mirage-flow-combinators ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS on Unix";
  };
}
