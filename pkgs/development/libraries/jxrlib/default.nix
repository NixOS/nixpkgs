{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "jxrlib";
  version = "1.1";

  # Use the source from a fork on github because CodePlex does not
  # deliver an easily downloadable tarball.
  src = fetchFromGitHub {
    owner = "4creators";
    repo = pname;
    rev = "f7521879862b9085318e814c6157490dd9dbbdb4";
    sha256 = "0rk3hbh00nw0wgbfbqk1szrlfg3yq7w6ar16napww3nrlm9cj65w";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian-phototools-team/jxrlib/-/raw/df96f9b9c1fbe9cdc97589c337f8a948bc81c4d0/debian/patches/usecmake.patch";
      sha256 = "sha256-BpCToLgA5856PZk5mXlwAy3Oh9aYP/2wvu2DXDTqufM=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian-phototools-team/jxrlib/-/raw/6c88037293aff8d5bc8a76ea32b36781c430ede3/debian/patches/bug803743.patch";
      sha256 = "sha256-omIGa+ZrWjaH/IkBn4jgjufF/HEDKw69anVCX4hw+xQ=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian-phototools-team/jxrlib/-/raw/b23d49062ec6a9b2739c9dade86be525a72fc807/debian/patches/pkg-config.patch";
      sha256 = "sha256-ZACaXEi+rbKIFBHtSBheyFfqV2HYsKKrT+SmTShyUhg=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = with lib; {
    description = "Implementation of the JPEG XR image codec standard";
    homepage = "https://jxrlib.codeplex.com";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
