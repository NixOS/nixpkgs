{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "semaphore-compat";
  version = "1.0.2";

  src = fetchurl {
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
