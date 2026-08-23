{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trf";
  version = "4.09.1";

  src = fetchFromGitHub {
    owner = "Benson-Genomics-Lab";
    repo = "trf";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-73LypVqBdlRdDCblf9JNZQmS5Za8xpId4ha5GjTJHDo=";
  };

  meta = {
    description = "Tandem Repeats Finder: a program to analyze DNA sequences";
    homepage = "https://tandem.bu.edu/trf/trf.html";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.unix;
  };
})
