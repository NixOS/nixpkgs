{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "recycle-bin.yazi";
<<<<<<< HEAD
  version = "0-unstable-2025-12-04";
=======
  version = "0-unstable-2025-11-11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "recycle-bin.yazi";
<<<<<<< HEAD
    rev = "53ad17c77746497e5146ad41fad94e6fc43e900b";
    hash = "sha256-CasCXkE8ig2INqx1mJj0wyxUVD1WFNM7aZ0SITXEsx0=";
=======
    rev = "1762676a032e0de6d4712ae06d14973670621f61";
    hash = "sha256-LzqFBLqaclRgjyLKL0OxlAao+MMivh4Ww7UZf2gcOUM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "A Recycle Bin for Yazi with browse, restore, and cleanup capabilities";
    homepage = "https://github.com/uhs-robert/recycle-bin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guttermonk ];
    platforms = lib.platforms.linux;
  };
}
