{
  lib,
  buildDunePackage,
  applyPatches,
  fetchpatch,
  fetchFromGitHub,
  lwt_ppx,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "ocsipersist-lib";
  version = "2.0.0";

  src = applyPatches {

    src = fetchFromGitHub {
      owner = "ocsigen";
      repo = "ocsipersist";
      tag = finalAttrs.version;
      hash = "sha256-7CKKwJxqxUpCMNs4xGbsMZ6Qud9AnczBStTXS+N21DU=";
    };

    patches = [
      # Migrate to logs
      (fetchpatch {
        url = "https://github.com/ocsigen/ocsipersist/commit/1fc0088b4dc2226f01863dd25f8ed56528c5543d.patch";
        hash = "sha256-WR7SW8jAAo47AIQ7UMQNF8FTXgj6FbxIqFjrLhu7wFs=";
        excludes = [
          "*.opam"
          "dune-project"
        ];
      })
    ];
  };

  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [ lwt ];

  meta = {
    description = "Persistent key/value storage (for Ocsigen) - support library";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocsigen/ocsipersist/";
  };
})
