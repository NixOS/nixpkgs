{ lib, buildDunePackage, fetchurl
, ppx_cstruct, ppx_tools
, cstruct, ounit, mmap, stdlib-shims
}:

buildDunePackage rec {
  pname = "pcap-format";
  version = "0.5.2";

  minimumOCamlVersion = "4.03";

  # due to cstruct
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-pcap/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "14c5rpgglyz41jic0fg0xa22d2w1syb86kva22y9fi7aqj9vm31f";
  };

  nativeBuildInputs = [
    ppx_tools
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    cstruct
    stdlib-shims
  ];

  doCheck = true;
  nativeCheckInputs = [
    ounit
    mmap
  ];

  meta = with lib; {
    description = "Decode and encode PCAP (packet capture) files";
    homepage = "https://mirage.github.io/ocaml-pcap";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
