{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zuo";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BUJtAKB2tz04LhkCsDWBjgTTymU4U3Zcdm+RDYawfxQ=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "CC_FOR_BUILD=cc"
  ];

  doCheck = true;
  enableParallelChecking = true;

  meta = {
    description = "Tiny Racket for Scripting";
    mainProgram = "zuo";
    homepage = "https://github.com/racket/zuo";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.RossSmyth ];
  };
})
