<<<<<<< HEAD
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
    homepage = "http://www.softsynth.com/pforth/";
    description = "Portable Portable ANS-like Forth written in ANSI 'C'";
    changelog = "https://github.com/philburk/pforth/blob/v${finalAttrs.version}/RELEASES.md";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ AndersonTorres yrashk ];
    platforms = lib.platforms.unix;
  };
})
# TODO: option for install the non-standalone executable
=======
{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation {
  version = "28";
  pname = "pforth";
  src = fetchFromGitHub {
    owner = "philburk";
    repo = "pforth";
    rev = "9190005e32c6151b76ac707b30eeb4d5d9dd1d36";
    sha256 = "0k3pmcgybsnwrxy75piyb2420r8d4ij190606js32j99062glr3x";
  };

  patches = [
    (fetchpatch {
      name = "gnumake-4.3-fix.patch";
      url = "https://github.com/philburk/pforth/commit/457cb99f57292bc855e53abcdcb7b12d6681e847.patch";
      sha256 = "0x1bwx3pqb09ddjhmdli47lnk1ys4ny42819g17kfn8nkjs5hbx7";
    })
  ];

  makeFlags = [ "SRCDIR=." ];
  makefile = "build/unix/Makefile";

  installPhase = ''
    install -Dm755 pforth_standalone $out/bin/pforth
  '';


  meta = {
    description = "Portable ANSI style Forth written in ANSI C";
    homepage = "http://www.softsynth.com/pforth/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yrashk ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
