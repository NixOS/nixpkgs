{
  lib,
  fetchgit,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "webdump";
  version = "0.3";

  src = fetchgit {
    url = "git://git.codemadness.org/webdump";
    tag = finalAttrs.version;
    hash = "sha256-XaqnFaCfTlzTkuMXrt1sQRCnO29yD1aCj/owmVAqDXU=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://www.codemadness.org/git/webdump";
    description = "HTML to plain-text converter for webpages";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ eyenx ];
    mainProgram = "webdump";
  };
})
