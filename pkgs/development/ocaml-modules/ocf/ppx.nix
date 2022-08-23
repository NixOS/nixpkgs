{ buildDunePackage, ocf, ppxlib }:

buildDunePackage {
  pname = "ocf_ppx";
  minimalOCamlVersion = "4.11";

  inherit (ocf) src version useDune2;

  buildInputs = [ ppxlib ocf ];

  meta = ocf.meta // {
    description = "Preprocessor for Ocf library";
  };
}
