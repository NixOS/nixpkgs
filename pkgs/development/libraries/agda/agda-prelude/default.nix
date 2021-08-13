{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  version = "compat-2.6.1";
  pname = "agda-prelude";

  src = fetchFromGitHub {
    owner = "UlfNorell";
    repo = "agda-prelude";
    rev = version;
    sha256 = "128rbhd32qlq2nq3wgqni4ih58zzwvs9pkn9j8236ycxxp6x81sl";
  };

  preConfigure = ''
    cd test
    make everything
    mv Everything.agda ..
    cd ..
  '';

  meta = with lib; {
    # Remove if a version compatible with agda 2.6.2 is made
    broken = true;
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ mudri alexarice turion ];
  };
}
