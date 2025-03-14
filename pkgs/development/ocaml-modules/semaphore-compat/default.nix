{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "semaphore-compat";
  version = "1.0.2";

  src = fetchurl {
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
