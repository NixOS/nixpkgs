{ lib, buildDunePackage, ocaml
, functoria, mirage-runtime
}:

buildDunePackage rec {
  pname = "mirage";
  inherit (mirage-runtime) version src;

  useDune2 = true;

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ functoria mirage-runtime ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$out --libdir=$dev/lib/ocaml/${ocaml.version}/site-lib/ ${pname}
    runHook postInstall
  '';

  meta = mirage-runtime.meta // {
    description = "The MirageOS library operating system";
  };

}
