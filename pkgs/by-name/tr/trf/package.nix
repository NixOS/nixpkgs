{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "trf";
  version = "4.09.1";

  src = fetchFromGitHub {
    owner = "Benson-Genomics-Lab";
    repo = "trf";
    rev = "v${version}";
    sha256 = "sha256-73LypVqBdlRdDCblf9JNZQmS5Za8xpId4ha5GjTJHDo=";
  };

  meta = with lib; {
    description = "Tandem Repeats Finder: a program to analyze DNA sequences";
    homepage = "https://tandem.bu.edu/trf/trf.html";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
