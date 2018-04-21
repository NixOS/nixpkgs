{ fetchFromGitHub, fetchpatch, stdenv, makeWrapper, unzip, libxml2, m4, uthash }:

stdenv.mkDerivation rec {
  name = "z88dk-${version}";
  version = "20180217";
  rev = "49a7c6032b2675af742f5b0b3aa5bd5260bdd814";
  short_rev = "${builtins.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo  = "z88dk";
    inherit rev;
    sha256 = "00vbklh6lkq1gyd08ig2vcg6c1mghvlwfx3vq3wldf34hcs3k4pp";
  };

  # https://github.com/z88dk/z88dk/pull/612
  patches = [(fetchpatch {
    url = "https://github.com/Mic92/z88dk/commit/5b4ca132fa1f31c9ac48cf2220358715739ca0b2.patch";
    sha256 = "1p2l31j68p7jzykhkhd9iagn2lr08hdclk3cl9l32p1q6ghdipfv";
  })];

  postPatch = ''
    # we dont rely on build.sh :
    export PATH="$PWD/bin:$PATH" # needed to have zcc in testsuite
    export ZCCCFG=$PWD/lib/config/
  '';

  makeFlags = [
    "prefix=$(out)"
    "git_rev=${short_rev}"
    "version=${version}"
    "git_count=0"
  ];
  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ libxml2 m4 uthash ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  installTargets = "libs install";

  meta = with stdenv.lib; {
    homepage    = https://www.z88dk.org;
    description = "z80 Development Kit";
    license     = licenses.clArtistic;
    maintainers = [ maintainers.genesis ];
    platforms = [ "x86_64-linux" ];
  };
}
