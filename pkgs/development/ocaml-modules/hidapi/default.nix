{ pkgs, lib, fetchurl, buildDunePackage, pkg-config
, bigstring,
}:

buildDunePackage rec {
  pname = "hidapi";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/vbmithr/ocaml-hidapi/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1j7rd7ajrzla76r3sxljx6fb18f4f4s3jd7vhv59l2ilxyxycai2";
  };

  minimumOCamlVersion = "4.03";

  buildInputs = [ pkgs.hidapi pkg-config ];
  propagatedBuildInputs = [ bigstring ];

  doCheck = true;

  meta = with lib; {
    homepage = https://github.com/vbmithr/ocaml-hidapi;
    description = "Bindings to Signal11's hidapi library";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
