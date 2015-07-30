{ stdenv, fetchFromGitHub }:

let version = "1.9.7"; in
stdenv.mkDerivation {
  name = "libcli-${version}";

  src = fetchFromGitHub {
    sha256 = "08pmjhqkwldhmcwjhi2l27slf1fk6nxxfaihnk2637pqkycy8z0c";
    rev = "v${version}";
    repo = "libcli";
    owner = "dparrish";
  };

  enableParallelBuilding = true;

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = http://sites.dparrish.com/libcli;
    license = licenses.lgpl21Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
