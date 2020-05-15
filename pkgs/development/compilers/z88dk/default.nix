{ fetchFromGitHub, stdenv, makeWrapper, unzip, libxml2, m4, uthash, which }:

stdenv.mkDerivation rec {
  pname = "z88dk-unstable";
  version = "2020-01-27";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo  = "z88dk";
    rev = "efdd07c2e2229cac7cfef97ec01f478004846e39";
    sha256 = "0jcks5ygp256lmzmllffp4yb38cxjgdyqnnimkj4s65095cfasyb";
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
  NIX_CFLAGS_COMPILE = "-O";

  short_rev = builtins.substring 0 7 src.rev;
  makeFlags = [
    "git_rev=${short_rev}"
    "version=${version}"
    "prefix=$(out)"
    "git_count=0"
  ];

  nativeBuildInputs = [ which makeWrapper unzip ];
  buildInputs = [ libxml2 m4 uthash ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  installTargets = [ "libs" "install" ];

  meta = with stdenv.lib; {
    homepage    = "https://www.z88dk.org";
    description = "z80 Development Kit";
    license     = licenses.clArtistic;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
