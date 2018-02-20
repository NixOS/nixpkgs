{ fetchFromGitHub, stdenv, makeWrapper, unzip, libxml2, m4, uthash }:

stdenv.mkDerivation rec {

  repo = "z88dk";
  version = "unstable-2018-02-21";
  rev = "57623766828abb0a9a75b7b6f0ffe3191dbf390c";
  short_rev = "${builtins.substring 0 7 rev}";
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit rev repo;
    owner = "z88dk";
    sha256 = "0q64k5rjk32asny8aw9afjsr2dc975m9bks2l6vsslsv2saxsf1v";
  };

  meta = with stdenv.lib; {
    homepage    = https://www.z88dk.org;
    description = "z80 Development Kit";
    license     = "Clarified-Artistic";
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

  patches = [ ./Makefile.patch ];

  postPatch =
  ''
    # we dont rely on build.sh :
    make clean
    export PATH="$PWD/bin:$PATH" # needed to have zcc in testsuite
    export ZCCCFG=$PWD/lib/config/
  '';

  makeFlags = [ "DESTDIR=$(out)" "prefix=/" "git_rev=${short_rev}"
                "version=${version}" "git_count=0"];
  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ libxml2 m4 uthash ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  installTargets = "libs install";
}
