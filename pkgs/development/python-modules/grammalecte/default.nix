{
  lib,
  buildPythonPackage,
  fetchurl,
  bottle,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "grammalecte";
  version = "2.1.1";
  format = "setuptools";

  src = fetchurl {
    url = "https://grammalecte.net/grammalecte/zip/Grammalecte-fr-v${version}.zip";
    sha256 = "076jv3ywdgqqzg92bfbagc7ypy08xjq5zn4vgna6j9350fkfqhzn";
  };

  patchPhase = ''
    runHook prePatch
    substituteInPlace grammalecte-server.py --replace sys.version_info.major sys.version_info
    runHook postPatch
  '';

  propagatedBuildInputs = [ bottle ];

  sourceRoot = ".";

  disabled = !isPy3k;

  meta = {
    description = "An open source grammar and typographic corrector for the French language";
    homepage = "https://grammalecte.net";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ apeyroux ];
  };
}
