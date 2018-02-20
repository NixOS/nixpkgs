{ fetchFromGitHub, stdenv, makeWrapper, unzip, libxml2, m4, uthash }:

stdenv.mkDerivation rec {

  repo = "z88dk";
  version = "unstable-2018-02-20";
  rev = "da4648333983e4b6755a343ba917a7e4af23de7c";
  short_rev = "${builtins.substring 0 7 rev}";
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit rev repo;
    owner = "z88dk";
    sha256 = "1iq9m9sjbsmwb39fdzii8lwjk3d8zq92jhh8dd7nmcdggqg81sy9";
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
