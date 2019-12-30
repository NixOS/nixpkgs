{ fetchFromGitHub, stdenv, makeWrapper, unzip, libxml2, m4, uthash, which }:

stdenv.mkDerivation rec {
  pname = "z88dk";
  version = "unstable-2019-05-09";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo  = "z88dk";
    rev = "826d68632c3a7c17df88dd2ec54571a6041da69c";
    sha256 = "104qgb01sdb97mkcxnq1cdlqi5qvjm4rd9bg5r42pdfz81ss49xj";
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
