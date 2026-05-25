{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zxcvbn-c";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "tsyrogit";
    repo = "zxcvbn-c";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/ATlpcx0XTtmzs6REA2YsnINKWz5xPNaetfhfyMuFP0=";
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
})
