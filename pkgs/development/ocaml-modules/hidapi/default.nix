{ pkgs, lib, fetchurl, buildDunePackage, pkg-config, dune-configurator
, bigstring,
}:

buildDunePackage rec {
  pname = "hidapi";
  version = "1.1.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/vbmithr/ocaml-hidapi/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1j7rd7ajrzla76r3sxljx6fb18f4f4s3jd7vhv59l2ilxyxycai2";
  };

  minimumOCamlVersion = "4.03";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pkgs.hidapi dune-configurator ];
  propagatedBuildInputs = [ bigstring ];

  doCheck = true;

  meta = with lib; {
    description = "Bindings to Signal11's hidapi library";
    homepage = "https://github.com/vbmithr/ocaml-hidapi";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
    mainProgram = "ocaml-hid-enumerate";
  };
}
