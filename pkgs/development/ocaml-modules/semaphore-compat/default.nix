{
  lib,
  buildDunePackage,
  fetchurl,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
=======
buildDunePackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "semaphore-compat";
  version = "1.0.2";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://github.com/mirage/semaphore-compat/releases/download/${finalAttrs.version}/semaphore-compat-${finalAttrs.version}.tbz";
    hash = "sha256-4CnZ2vX17IPpnlA7CNeuxZEKfA5HFoeQvwH0tCKNRnY=";
  };

  meta = {
    description = "Compatibility Semaphore module";
    homepage = "https://github.com/mirage/semaphore-compat";
    license = with lib.licenses; [
      lgpl21Plus
      ocamlLgplLinkingException
    ];
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
=======
    url = "https://github.com/mirage/semaphore-compat/releases/download/${version}/semaphore-compat-${version}.tbz";
    sha256 = "sha256-4CnZ2vX17IPpnlA7CNeuxZEKfA5HFoeQvwH0tCKNRnY=";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Compatibility Semaphore module";
    homepage = "https://github.com/mirage/semaphore-compat";
    license = with licenses; [
      lgpl21Plus
      ocamlLgplLinkingException
    ];
    maintainers = [ maintainers.sternenseemann ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
