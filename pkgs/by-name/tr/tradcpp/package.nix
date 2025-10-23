{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tradcpp";
  version = "0.5.3";

  src = fetchurl {
    url = "https://ftp.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-${finalAttrs.version}.tar.gz";
    hash = "sha256-4XufQs90s2DVaRvFn7U/N+QVgcRbdfzWS7ll5eL+TF4=";
  };

  # tradcpp only comes with BSD-make Makefile; the patch adds configure support
  patches = [ ./tradcpp-configure.patch ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Traditional (K&R-style) C macro preprocessor";
    mainProgram = "tradcpp";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
  };
})
