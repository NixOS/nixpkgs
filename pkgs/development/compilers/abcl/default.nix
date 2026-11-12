{
  lib,
  stdenv,
  writeShellScriptBin,
  fetchurl,
  ant,
  openjdk17,
  makeWrapper,
  stripJavaArchivesHook,
}:

let
  # https://armedbear.common-lisp.dev/ lists OpenJDK 17 as the highest
  # supported JDK.
  jdk = openjdk17;

  fakeHostname = writeShellScriptBin "hostname" ''
    echo nix-builder.localdomain
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "abcl";
  version = "1.9.3";

  src = fetchurl {
    url = "https://common-lisp.net/project/armedbear/releases/${finalAttrs.version}/abcl-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-uwShIj06mGCS4BD/2tE69QQp1VwagYdL8wIvlDa/sv8=";
  };

  # note for the future:
  # if you use makeBinaryWrapper, you will trade bash for glibc, the closure will be slightly larger
  nativeBuildInputs = [
    ant
    jdk
    fakeHostname
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    ant \
      -Dabcl.runtime.jar.path="$out/lib/abcl/abcl.jar" \
      -Dadditional.jars="$out/lib/abcl/abcl-contrib.jar"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{share/doc/abcl,lib/abcl}
    cp -r README COPYING CHANGES examples/  "$out/share/doc/abcl/"
    cp -r dist/*.jar contrib/ "$out/lib/abcl/"
    install -Dm555 abcl -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "JVM-based Common Lisp implementation";
    homepage = "https://common-lisp.net/project/armedbear/";
    license = with lib.licenses; [
      gpl2
      classpathException20
    ];
    mainProgram = "abcl";
    teams = [ lib.teams.lisp ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
