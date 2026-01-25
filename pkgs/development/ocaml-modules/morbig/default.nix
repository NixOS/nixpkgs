{
  lib,
  ocaml,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  menhirLib,
  ppx_deriving_yojson,
  visitors,
}:

buildDunePackage (finalAttrs: {
  pname = "morbig";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "colis-anr";
    repo = "morbig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fOBaJHHP/Imi9UDLflI52OdKDcmMxpl+NH3pfofmv/o=";
  };

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    menhirLib
    ppx_deriving_yojson
    visitors
  ];

  meta = {
    homepage = "https://github.com/colis-anr/morbig";
    description = "Static parser for POSIX Shell";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ niols ];
    broken = lib.versionAtLeast ocaml.version "5.4";
  };
})
