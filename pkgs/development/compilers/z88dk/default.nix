{ fetchFromGitHub, stdenv, makeWrapper, unzip, libxml2, m4, uthash }:

stdenv.mkDerivation rec {

  pname = "z88dk";
  version = "20180217";
  rev = "49a7c6032b2675af742f5b0b3aa5bd5260bdd814";
  short_rev = "${builtins.substring 0 7 rev}";
  name = "${pname}-${version}-${short_rev}";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo  = "${pname}";
    rev = "${rev}";
    sha256 = "0jd312jcl0rqn15c2nbllpqz2x67hwvkhlz2smbqjyv8mrbhqbcc";
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
