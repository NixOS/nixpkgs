{ libraw, fetchFromGitHub }:

libraw.overrideAttrs (_: rec {
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = version;
    sha256 = "16nm4r2l5501c9zvz25pzajq5id592jhn068scjxhr8np2cblybc";
  };
})
