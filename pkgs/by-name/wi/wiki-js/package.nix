{
  stdenv,
  fetchurl,
  lib,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wiki-js";
  version = "2.5.311";

  src = fetchurl {
    url = "https://github.com/Requarks/wiki/releases/download/v${finalAttrs.version}/wiki-js.tar.gz";
    hash = "sha256-XNWJ2XyjTJmt+/Yjiu+w2nIZS9fqlyi11aiV5V4ekwI=";
  };

  # Unpack the tarball into a subdir. All the contents are copied into `$out`.
  # Unpacking into the parent directory would also copy `env-vars` into `$out`
  # in the `installPhase` which ultimately means that the package retains
  # references to build tools and the tarball.
  preUnpack = ''
    mkdir source
    cd source
  '';

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r . $out

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) wiki-js; };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://js.wiki/";
    description = "Modern and powerful wiki app built on Node.js";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
})
