{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-build-info,
  ppx_inline_test_nobase,
  ppxlib,
  sexplib,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_expect_nobase";
  version = "0.17.3.2";

  minimalOCamlVersion = "4.14.2";

  src = fetchFromGitHub {
    owner = "Kakadu";
    repo = "ppx_expect_nobase";
    tag = finalAttrs.version;
    hash = "sha256-tLuq1O+FI8hLRuMrEZKXeDuN+QvMrqF0etkczYZTF5A=";
  };

  propagatedBuildInputs = [
    dune-build-info
    ppx_inline_test_nobase
    ppxlib
    sexplib
  ];

  meta = {
    description = "Cram like framework for OCaml";
    homepage = "https://github.com/Kakadu/ppx_expect_nobase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    broken = lib.versionOlder ppxlib.version "0.37";
  };
})
