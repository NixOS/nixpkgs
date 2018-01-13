{ stdenv, fetchgit }:
stdenv.mkDerivation rec {
  name = "libzxcvbn0_${version}";
  version = "2.3";

  src = fetchgit {
    url = "https://github.com/tsyrogit/zxcvbn-c";
    rev = "50b74db43bc3467b3fbf28b10606e955b40566ed";
    sha256 = "1m097b4qq1r3kk4b236pc3mpaj22il9fh43ifagad5wy54x8zf7b";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp -R libzxcvbn.so* $out/lib/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tsyrogit/zxcvbn-c;
    description = "A C/C++ implementation of the zxcvbn password strength estimation";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xurei ];
  };
}
