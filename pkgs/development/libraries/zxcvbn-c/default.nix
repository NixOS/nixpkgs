{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "zxcvbn-c-${version}";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "tsyrogit";
    repo = "zxcvbn-c";
    rev = "v${version}";
    sha256 = "1m097b4qq1r3kk4b236pc3mpaj22il9fh43ifagad5wy54x8zf7b";
  };

  installPhase = ''
    install -D -t $out/lib libzxcvbn.so*
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tsyrogit/zxcvbn-c;
    description = "A C/C++ implementation of the zxcvbn password strength estimation";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xurei ];
  };
}
