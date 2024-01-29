{ lib
, stdenv
, fetchFromGitHub
, buildPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pforth";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "philburk";
    repo = "pforth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vEjFeHSJl+yAtatYJEnu+r9hmOr/kZOgIbSUXR/c8WU=";
  };

  # We build the dictionary in a cross-compile compatible way.
  # For that, we perform steps, that the Makefile would otherwise do.
  buildPhase = ''
    runHook preBuild
    make -C platforms/unix pfdicapp
    pushd fth/
    ${stdenv.hostPlatform.emulator buildPackages} ../platforms/unix/pforth -i system.fth
    ${stdenv.hostPlatform.emulator buildPackages} ../platforms/unix/pforth -d pforth.dic <<< "include savedicd.fth sdad bye"
    mv pforth.dic pfdicdat.h ../platforms/unix/
    popd
    make -C platforms/unix pforthapp
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 platforms/unix/pforth_standalone $out/bin/pforth
    mkdir -p $out/share/pforth
    cp -r fth/* $out/share/pforth/
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.softsynth.com/pforth/";
    description = "Portable Portable ANS-like Forth written in ANSI 'C'";
    changelog = "https://github.com/philburk/pforth/blob/v${finalAttrs.version}/RELEASES.md";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ AndersonTorres yrashk ];
    platforms = lib.platforms.unix;
  };
})
# TODO: option for install the non-standalone executable
