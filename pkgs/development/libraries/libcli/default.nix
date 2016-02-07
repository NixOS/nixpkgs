{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libcli-${version}";
  version = "1.9.7";

  src = fetchFromGitHub {
    sha256 = "08pmjhqkwldhmcwjhi2l27slf1fk6nxxfaihnk2637pqkycy8z0c";
    rev = "v${version}";
    repo = "libcli";
    owner = "dparrish";
  };

  patches = [
    (fetchpatch {
      url = https://patch-diff.githubusercontent.com/raw/dparrish/libcli/pull/21.diff;
      sha256 = "150nm33xi3992zx8a9smjzd8zs7pavrwg1pijah6nyl22q9gxm21";
    })
  ];

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = http://sites.dparrish.com/libcli;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
