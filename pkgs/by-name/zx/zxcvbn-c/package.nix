{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zxcvbn-c";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "tsyrogit";
    repo = "zxcvbn-c";
    rev = "v${version}";
    sha256 = "sha256-RKqbv0iGkjS7Y7KikqglZ+AK1oiw4G1mB2Zg87tOlbI=";
  };

  installPhase = ''
    install -D -t $out/lib libzxcvbn.so*
  '';

  meta = {
    homepage = "https://github.com/tsyrogit/zxcvbn-c";
    description = "C/C++ implementation of the zxcvbn password strength estimation";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ xurei ];
  };
}
