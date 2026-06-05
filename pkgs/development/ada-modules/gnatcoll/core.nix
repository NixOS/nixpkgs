{
  stdenv,
  lib,
  gnat,
  gprbuild,
  fetchFromGitHub,
  which,
  python3,
  rsync,
  enableGnatcollCore ? true,
  # TODO(@sternenseemann): figure out a way to split this up into three packages
  enableGnatcollProjects ? true,
  # for tests
  gnatcoll-core,
}:

# gnatcoll-projects depends on gnatcoll-core
assert enableGnatcollProjects -> enableGnatcollCore;

stdenv.mkDerivation (finalAttrs: {
  pname = "gnatcoll-core";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oTFUdcx14TavJ2kxBEbfZVWvKEurcOpd5U7n1QZ+fZI=";
  };

  postPatch = ''
    patchShebangs */*.gpr.py
  '';

  nativeBuildInputs = [
    gprbuild
    which
    gnat
    python3
    rsync
  ];

  # propagate since gprbuild needs to find
  # referenced GPR project definitions
  propagatedBuildInputs = lib.optionals enableGnatcollProjects [
    gprbuild # libgpr
  ];

  strictDeps = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    # confusingly, for gprbuild --target is autoconf --host
    "TARGET=${stdenv.hostPlatform.config}"
    "GNATCOLL_MINIMAL_ONLY=${lib.boolToYesNo (!enableGnatcollCore)}"
    "GNATCOLL_PROJECTS=${lib.boolToYesNo enableGnatcollProjects}"
  ];

  passthru.tests = {
    minimalOnly = gnatcoll-core.override {
      enableGnatcollProjects = false;
      enableGnatcollCore = false;
    };
    noProjects = gnatcoll-core.override {
      enableGnatcollProjects = false;
      enableGnatcollCore = true;
    };
  };

  meta = {
    homepage = "https://github.com/AdaCore/gnatcoll-core";
    description = "GNAT Components Collection - Core packages";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      sternenseemann
      sempiternal-aurora
    ];
    platforms = lib.platforms.all;
  };
})
