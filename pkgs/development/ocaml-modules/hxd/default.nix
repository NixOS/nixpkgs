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
  version = "0.3.5";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-${version}.tbz";
    sha256 = "sha256-E1I198ErT9/Cpvdk/Qjpq360OIVuAsbmaNc7qJzndEM=";
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

  meta = with lib; {
    description = "Hexdump in OCaml";
    homepage = "https://github.com/dinosaure/hxd";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "hxd.xxd";
  };
}
