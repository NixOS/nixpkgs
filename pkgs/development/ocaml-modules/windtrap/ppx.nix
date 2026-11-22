{
  buildDunePackage,
  ocaml,
  windtrap,
  ppxlib,
}:

buildDunePackage {
  pname = "ppx_windtrap";
  inherit (windtrap) version src;

  minimalOCamlVersion = "5.3";

  propagatedBuildInputs = [
    windtrap
    ppxlib
  ];

  nativeCheckInputs = [ windtrap ];

  # Nixpkgs+buildDunePackage puts *.cmi files in site-lib of windtrap’s dev
  # output. We need to rewrite its location to be picked up for compilation to
  # do the golden asserts.
  postPatch = ''
    substituteInPlace test/conformance/corpus/example/dune \
      --replace-fail '%{ocaml_where}/../windtrap' \
        "${windtrap.dev}/lib/ocaml/${ocaml.version}/site-lib/windtrap"
  '';

  doCheck = true;

  # skip “collapse_home” tests, because $HOME ≠ getpwuid in the sandbox
  preCheck = ''
    unset HOME
  '';

  meta = windtrap.meta // {
    description = "PPX and instrumentation backend for windtrap";
  };
}
