{
  lib,
  stdenv,
  fetchurl,
  pkgs,
  undmg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "racket-bin";
  version = "8.16";
  src =
    {
      aarch64-darwin = fetchurl {
        url = "https://download.racket-lang.org/releases/${finalAttrs.version}/installers/racket-${finalAttrs.version}-aarch64-macosx-cs.dmg";
        sha256 = "a15727e5eb8da18d81839c9f552e388217d49917a86298a83c9d280b249de8f7";
      };
      x86_64-darwin = fetchurl {
        url = "https://download.racket-lang.org/releases/${finalAttrs.version}/installers/racket-${finalAttrs.version}-x86_64-macosx-cs.dmg";
        sha256 = "4b7b3665cd1fae4845e3a7ff4e7f2c4fc9e5a2edf2d776a0dc58aa56e3469538";
      };
    }
    ."${stdenv.buildPlatform.system}";

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  buildPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r "Racket v${finalAttrs.version}/"*.app "$out/Applications"
    cp -r "Racket v${finalAttrs.version}/"{bin,collects,doc,etc,include,lib,man,share} $out

    runHook postInstall
  '';
  dontStrip = true;

  meta = {
    description = "Programmable programming language (binary distribution)";
    longDescription = ''
      Racket is a full-spectrum programming language. It goes beyond
      Lisp and Scheme with dialects that support objects, types,
      laziness, and more. Racket enables programmers to link
      components written in different dialects, and it empowers
      programmers to create new, project-specific dialects. Racket's
      libraries support applications from web servers and databases to
      GUIs and charts.

      This derivation based on the binary distribution of Racket is
      intended for use on Darwin/Mac OS, where the source build is
      especially finicky and prone to breaking.
    '';
    homepage = "https://racket-lang.org/";
    changelog = "https://github.com/racket/racket/releases/tag/v${finalAttrs.version}";
    /*
      > Racket is distributed under the MIT license and the Apache version 2.0
      > license, at your option.

      > The Racket runtime system embeds Chez Scheme, which is distributed
      > under the Apache version 2.0 license.
    */
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dpk ];
    mainProgram = "racket";
    platforms = lib.platforms.darwin;
  };
})
