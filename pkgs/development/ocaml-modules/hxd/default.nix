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
<<<<<<< HEAD
  version = "0.3.6";
=======
  version = "0.3.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-${version}.tbz";
<<<<<<< HEAD
    sha256 = "sha256-eh3yDF3QG33Ztf/i3nIWtZiWUqsyUXVRIyeiad3t87k=";
=======
    sha256 = "sha256-E1I198ErT9/Cpvdk/Qjpq360OIVuAsbmaNc7qJzndEM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Hexdump in OCaml";
    homepage = "https://github.com/dinosaure/hxd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
=======
  meta = with lib; {
    description = "Hexdump in OCaml";
    homepage = "https://github.com/dinosaure/hxd";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hxd.xxd";
  };
}
