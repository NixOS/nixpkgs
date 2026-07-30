{
  lib,
  fetchgit,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "webdump";
  version = "0.2";

  src = fetchgit {
    url = "git://git.codemadness.org/webdump";
    tag = finalAttrs.version;
    hash = "sha256-YtgZkAnbQkIr2fhUYpSp/PaduuBFjxIkrkaROxrmT/0=";
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
