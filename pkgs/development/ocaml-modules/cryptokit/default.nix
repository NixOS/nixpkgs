{
  lib,
  buildDunePackage,
  ocaml,
  fetchFromGitHub,
  zlib,
  dune-configurator,
  zarith,
  version ? if lib.versionAtLeast ocaml.version "4.13" then "1.21.1" else "1.20.1",
}:

buildDunePackage (finalAttrs: {
  pname = "cryptokit";
  inherit version;

  src = fetchFromGitHub {
    owner = "xavierleroy";
    repo = "cryptokit";
    tag = "release${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash =
      {
        "1.21.1" = "sha256-9JU9grZpTTrYYO9gai2UPq119HfenI1JAY+EyoR6x7Q=";
        "1.20.1" = "sha256-VFY10jGctQfIUVv7dK06KP8zLZHLXTxvLyTCObS+W+E=";
      }
      ."${finalAttrs.version}";
  };

  # dont do autotools configuration, but do trigger findlib's preConfigure hook
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    zarith
    zlib
  ];

  doCheck = true;

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "Library of cryptographic primitives for OCaml";
    license = lib.licenses.lgpl2Only;
  };
})
