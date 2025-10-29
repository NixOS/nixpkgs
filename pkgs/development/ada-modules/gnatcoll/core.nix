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
    # Fix compilation with GNAT 12 https://github.com/AdaCore/gnatcoll-core/issues/88
    (fetchpatch2 {
      name = "gnatcoll-core-gnat-12.patch";
      url = "https://github.com/AdaCore/gnatcoll-core/commit/515db1c9f1eea8095f2d9ff9570159a78c981ec6.patch";
      sha256 = "1ghnkhp5fncb7qcmf59kyqvy0sd0pzf1phnr2z7b4ljwlkbmcp36";
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

  meta = with lib; {
    homepage = "https://github.com/AdaCore/gnatcoll-core";
    description = "GNAT Components Collection - Core packages";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.all;
  };
}
