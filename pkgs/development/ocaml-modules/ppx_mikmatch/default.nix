{
  buildDunePackage,
  fetchurl,
  lib,
  menhir,
  ounit2,
  ppxlib,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_mikmatch";
  version = "1.3";
  src = fetchurl {
    name = "ppx_mikmatch-${finalAttrs.version}.tar.gz";
    url = "https://codeload.github.com/ahrefs/ppx_mikmatch/tar.gz/refs/tags/${finalAttrs.version}";
    hash = "sha256-i97gSyutefbJbDZv/yjaeHfV1CU6j3RSaQ1oPjiz8hg=";
  };

  minimalOCamlVersion = "5.3";

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    ppxlib
    re
  ];

  checkInputs = [ ounit2 ];
  doCheck = true;

  meta = {
    description = "Matching Regular Expressions with OCaml Patterns using Mikmatch's syntax";
    homepage = "https://github.com/ahrefs/ppx_mikmatch";
    license = lib.licenses.lgpl3Plus;
    maintainers = [
      lib.maintainers.vog
      lib.maintainers.zazedd
    ];
  };
})
