{
  lib,
  buildDunePackage,
  fetchurl,
  ppx_cstruct,
  cstruct,
  ounit,
}:

buildDunePackage (finalAttrs: {
  pname = "pcap-format";
  version = "0.6.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-pcap/releases/download/v${finalAttrs.version}/pcap-format-${finalAttrs.version}.tbz";
    hash = "sha256-LUjy8Xm6VsnMq1FHKzmJg7uorkTv7cOTsoLwmtNHkaY=";
  };

  buildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    cstruct
  ];

  doCheck = true;
  checkInputs = [
    ounit
  ];

  meta = {
    description = "Decode and encode PCAP (packet capture) files";
    homepage = "https://mirage.github.io/ocaml-pcap";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
