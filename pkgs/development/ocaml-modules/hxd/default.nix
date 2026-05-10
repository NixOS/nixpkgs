{
  lib,
  buildDunePackage,
  fetchurl,
  dune-configurator,
  cmdliner,
  lwt,
  withLwt ? true,
}:

buildDunePackage rec {
  pname = "hxd";
  version = "0.4.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-${version}.tbz";
    sha256 = "sha256-EAMLciahdQRHGAmtWvwMIAchJkxcbdPVldJIBApxgFg=";
  };

  propagatedBuildInputs = lib.optional withLwt lwt;

  buildInputs = [
    cmdliner
    dune-configurator
  ];

  doCheck = true;

  preCheck = ''
    export DUNE_CACHE=disabled
  '';

  meta = {
    description = "Hexdump in OCaml";
    homepage = "https://github.com/dinosaure/hxd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    mainProgram = "hxd.xxd";
  };
}
