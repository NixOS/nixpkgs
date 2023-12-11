{ fetchurl
, fetchFromGitHub
}:

let
  # Lifted from the Wine package
  fetchurl' = args@{url, hash, ...}:
    fetchurl { inherit url hash; } // args;

  fetchFromGitHub' = args@{owner, repo, rev, hash, ...}:
    fetchFromGitHub { inherit owner repo rev hash; } // args;
in {
  target = "powerpc-eabi";

  buildscripts = fetchFromGitHub' rec {
    version = "44.2";
    hash = "sha256-nrencSFHIommdZyEO3HFLuMU8B0Gz0U2x+U56ZSMOs8=";
    owner = "devkitPro";
    repo = "buildscripts";
    rev = "devkitPPC_r${version}";
  };

  rules = fetchFromGitHub' rec {
    version = "1.2.1";
    hash = "sha256-SnbsyvnEQcHkLTVZBPat0lk+Dr/7OT/MrR036gxGe98=";
    owner = "devkitPro";
    repo = "devkitppc-rules";
    rev = "v${version}";
  };

  binutils = fetchurl' rec {
    version = "2.41";
    url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
    hash = "sha256-pMS+wFL3uDcAJOYDieGUN38/SLVmGEGOpRBn9nqqsws=";
  };

  gcc = fetchurl' rec {
    version = "13.2.0";
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-4nXnZEKmBnNBon8Exca4PYYTFEAEwEE1KIY9xrXHQ9o=";
  };

  newlib = fetchurl' rec {
    version = "4.3.0.20230120";
    url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
    hash = "sha256-g6Yqma9Z4465sMWO0JLuJNcA//Q6IsA+QzlVET7zUVA=";
  };
}
