{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zxcvbn-c";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "tsyrogit";
    repo = "zxcvbn-c";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xvdoH+r3kcFpsgJ0po/S5Q6m6yxVitxp+DP+kLS5YRI=";
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
