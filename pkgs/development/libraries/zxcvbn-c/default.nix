{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "zxcvbn-c";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "tsyrogit";
    repo = "zxcvbn-c";
    rev = "v${version}";
    sha256 = "12ksdnpxlqlmg9zhyyk3bspcf0sfj5zk735vr4ry635qi7gzcaas";
  };

  installPhase = ''
    install -D -t $out/lib libzxcvbn.so*
  '';

  meta = with lib; {
    homepage = "https://github.com/tsyrogit/zxcvbn-c";
    description = "A C/C++ implementation of the zxcvbn password strength estimation";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xurei ];
  };
}
