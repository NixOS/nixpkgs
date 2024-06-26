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
  version = "0.3.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-${version}.tbz";
    sha256 = "a00290abb8538e79b32ddc22ed9b301b9806bc4c03eb1e5105b14af47dabec9f";
  };

  propagatedBuildInputs = lib.optional withLwt lwt;

  buildInputs = [
    cmdliner
    dune-configurator
  ];

  doCheck = true;

  meta = with lib; {
    description = "Hexdump in OCaml";
    homepage = "https://github.com/dinosaure/hxd";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "hxd.xxd";
  };
}
