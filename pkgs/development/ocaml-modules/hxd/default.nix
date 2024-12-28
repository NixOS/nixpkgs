{ lib, buildDunePackage, fetchurl
, dune-configurator, cmdliner
, lwt, withLwt ? true
}:

buildDunePackage rec {
  pname = "hxd";
  version = "0.3.3";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-${version}.tbz";
    sha256 = "sha256-Tt4jUpal4qJZl3bIvOtIU8Fk735XNXCh7caKTAyQQz4=";
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
