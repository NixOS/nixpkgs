{
  fetchFromGitHub,
  lib,
  stdenv,
  makeWrapper,
  unzip,
  libxml2,
  gmp,
  m4,
  uthash,
  which,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "z88dk";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo = "z88dk";
    rev = "v${version}";
    sha256 = "sha256-CHTORgK6FYIO6n+cvTUX4huY2Ek5FuHrs40QN5NZX44=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # we dont rely on build.sh :
    export PATH="$PWD/bin:$PATH" # needed to have zcc in testsuite
    export ZCCCFG=$PWD/lib/config/
    # we don't want to build zsdcc since it required network (svn)
    # we test in checkPhase
    substituteInPlace Makefile \
      --replace 'testsuite bin/z88dk-lib$(EXESUFFIX)' 'bin/z88dk-lib$(EXESUFFIX)'\
      --replace 'ALL_EXT = bin/zsdcc$(EXESUFFIX)' 'ALL_EXT ='
  '';

  checkPhase = ''
    make testsuite
  '';
  #failed on Issue_1105_function_pointer_calls
  doCheck = stdenv.hostPlatform.system != "aarch64-linux";

  #_FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = "-O";

  short_rev = builtins.substring 0 7 src.rev;
  makeFlags = [
    "git_rev=${short_rev}"
    "version=${version}"
    "DESTDIR=$(out)"
    "git_count=0"
  ];

  nativeBuildInputs = [
    which
    makeWrapper
    unzip
    pkg-config
  ];
  buildInputs = [
    libxml2
    m4
    uthash
    gmp
  ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  installTargets = [
    "libs"
    "install"
  ];

  meta = with lib; {
    homepage = "https://www.z88dk.org";
    description = "z80 Development Kit";
    license = licenses.clArtistic;
    maintainers = [ maintainers.siraben ];
    platforms = platforms.unix;
  };
}
