{ buildDunePackage
, dune-configurator
, lib
, fetchurl
, ppx_expect
, ppx_optcomp
}:

buildDunePackage rec {
  pname = "kqueue";
  version = "0.4.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/anuragsoni/kqueue-ml/releases/download/${version}/kqueue-${version}.tbz";
    hash = "sha256-fJHhmAp0EFzR9JH93a+EHy1auwSBKZV/XcBQLCedJLc=";
  };

  buildInputs = [
    dune-configurator
    ppx_optcomp
  ];

  checkInputs = [
    ppx_expect
  ];

  doCheck = true;

  meta = {
    description = "OCaml bindings for kqueue event notification interface";
    homepage = "https://github.com/anuragsoni/kqueue-ml";
    changelog = "https://github.com/anuragsoni/kqueue-ml/blob/${version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}

