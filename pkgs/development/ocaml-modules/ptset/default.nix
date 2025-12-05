{
  lib,
  fetchurl,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "ptset";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/backtracking/ptset/releases/download/${finalAttrs.version}/ptset-${finalAttrs.version}.tbz";
    hash = "sha256-RJARnuDrQPmxSLA0MobuKjNmltja8YBbHYmKMF8FKN8=";
  };

  doCheck = true;

  propagatedBuildInputs = [ stdlib-shims ];

  meta = {
    description = "Integer set implementation using Patricia trees";
    homepage = "https://github.com/backtracking/ptset";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
