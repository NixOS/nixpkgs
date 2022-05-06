{ lib, buildDunePackage, fetchurl
, ocaml, dune-configurator, cmdliner
, lwt, withLwt ? lib.versionAtLeast ocaml.version "4.07"
}:

buildDunePackage rec {
  pname = "hxd";
  version = "0.3.1";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-v${version}.tbz";
    sha256 = "1c226c91e17cd329dec0c287bfd20f36302aa533069ff9c6ced32721f96b29bc";
  };

  # ignore yes stderr output due to trapped SIGPIPE
  postPatch = ''
    sed -i 's|yes ".\+"|& 2> /dev/null|' test/*.t
  '';

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
  };
}
