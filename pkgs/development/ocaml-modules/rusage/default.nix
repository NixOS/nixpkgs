{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "rusage";
  version = "1.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/CraigFe/ocaml-rusage/releases/download/${version}/rusage-${version}.tbz";
    hash = "sha256-OgYA2Fe1goqoaOS45Z6FBJNNYN/uq+KQoUwG8KSo6Fk=";
  };

  meta = {
    description = "Bindings to the GETRUSAGE(2) syscall";
    homepage = "https://github.com/CraigFe/ocaml-rusage";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
