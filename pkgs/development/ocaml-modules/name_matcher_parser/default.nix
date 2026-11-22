{
  lib,
  buildDunePackage,
  charon,

  # nativeBuildInputs,
  menhir,

  # propagatedBuildInputs,
  menhirLib,
  ppx_deriving,
  visitors,
  zarith,
}:

buildDunePackage (finalAttrs: {
  pname = "name_matcher_parser";
  inherit (charon) version;
  __structuredAttrs = true;

  inherit (charon) src;

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [
    menhirLib
    ppx_deriving
    visitors
    zarith
  ];

  # No test suite is defined for this package.
  doCheck = false;

  meta = {
    description = "Parser to define name matchers";
    homepage = "https://github.com/AeneasVerif/charon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
