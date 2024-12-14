{
  buildDunePackage,
  ocf,
  ppxlib,
}:

buildDunePackage {
  pname = "ocf_ppx";
  minimalOCamlVersion = "4.11";

  inherit (ocf) src version;

  duneVersion = "3";

  buildInputs = [
    ppxlib
    ocf
  ];

  meta = ocf.meta // {
    description = "Preprocessor for Ocf library";
  };
}
