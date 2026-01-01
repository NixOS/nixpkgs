{
  lib,
  buildDunePackage,
  fetchurl,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "atdgen-codec-runtime";
  version = "3.0.1";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${finalAttrs.version}/atd-${finalAttrs.version}.tbz";
    hash = "sha256-A66uRWWjLYu2ishRSvXvx4ALFhnClzlBynE4sSs0SIQ=";
=======
buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.16.0";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atd-${version}.tbz";
    hash = "sha256-Wea0RWICQcvWkBqEKzNmg6+w6xJbOtv+4ovZTNVODe8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
