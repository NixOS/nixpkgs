{ lib, buildDunePackage, fetchurl, zlib, dune-configurator, zarith, ncurses }:

buildDunePackage {
  pname = "cryptokit";
  version = "1.16.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/xavierleroy/cryptokit/archive/release1161.tar.gz";
    sha256 = "0kzqkk451m69nqi5qiwak0rd0rp5vzi613gcngsiig7dyxwka61c";
  };

  # dont do autotools configuration, but do trigger findlib's preConfigure hook
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildInputs = [ dune-configurator ncurses ];
  propagatedBuildInputs = [ zarith zlib ];

  doCheck = true;

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "A library of cryptographic primitives for OCaml";
    license = lib.licenses.lgpl2Only;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
