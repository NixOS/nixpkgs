{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  mtime,
  ppxlib,
  sexplib0,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_inline_test_nobase";
  version = "0.17.0.3";

  minimalOCamlVersion = "4.14.2";

  src = fetchFromGitHub {
    owner = "Kakadu";
    repo = "ppx_inline_test_nobase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bsw+jtPfONeiRoAGYhD3Ty9Pu+pUYmg94mGY3cCqqp4=";
  };

  propagatedBuildInputs = [
    mtime
    ppxlib
    sexplib0
  ];

  meta = {
    description = "Syntax extension for writing in-line tests in ocaml code";
    homepage = "https://github.com/Kakadu/ppx_inline_test_nobase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    broken = lib.versionOlder ppxlib.version "0.37";
  };
})
