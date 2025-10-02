{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zxcvbn-c";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "tsyrogit";
    repo = "zxcvbn-c";
    rev = "v${version}";
    sha256 = "sha256-/ATlpcx0XTtmzs6REA2YsnINKWz5xPNaetfhfyMuFP0=";
  };

  installPhase = ''
    install -D -t $out/lib libzxcvbn.so*
  '';

  meta = with lib; {
    homepage = "https://github.com/tsyrogit/zxcvbn-c";
    description = "C/C++ implementation of the zxcvbn password strength estimation";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xurei ];
  };
}
