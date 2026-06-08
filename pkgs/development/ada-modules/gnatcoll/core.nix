{
  stdenv,
  lib,
  gnat,
  gprbuild,
  fetchFromGitHub,
  fetchpatch2,
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

stdenv.mkDerivation rec {
  pname = "gnatcoll-core";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-core";
    rev = "v${version}";
    sha256 = "1srnh7vhs46c2zy4hcy4pg0a0prghfzlpv7c82k0jan384yz1g6g";
  };

  patches = [
    # Fix compilation with GNAT 16
    (fetchpatch2 {
      name = "gnatcoll-core-gnat-16.patch";
      url = "https://github.com/AdaCore/gnatcoll-core/commit/b266466e0a05b30615ec43d72782c345470455b9.patch?full_index=1";
      hash = "sha256-rG0D1y2dbXA2M2Arnto+f7iAhg3yCfTPDbDRN+pMJKQ=";
    })
  ];

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
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.all;
  };
}
