{
  lib,
  fetchurl,
  fetchpatch,
  buildDunePackage,
  ocaml,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "facile";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/Emmanuel-PLF/facile/releases/download/${finalAttrs.version}/facile-${finalAttrs.version}.tbz";
    sha256 = "0jqrwmn6fr2vj2rrbllwxq4cmxykv7zh0y4vnngx29f5084a04jp";
  };

  patches = fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/Emmanuel-PLF/facile/pull/4.patch";
    excludes = [ "Makefile" ];
    hash = "sha256-syZO3lzuHxE2Y4yUaS+XgAQUFtLrENy2MwyWzPygfdg=";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  doCheck = true;

  meta = {
    homepage = "http://opti.recherche.enac.fr/facile/";
    license = lib.licenses.lgpl21Plus;
    description = "Functional Constraint Library";
    broken = lib.versionAtLeast ocaml.version "5.0";
  };
})
