{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_inline_test,
  ppx_expect,
  opam-file-format,
}:

buildDunePackage (finalAttrs: {
  pname = "ez_opam_file";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ez_opam_file";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L8IjDrmaA88sE43hTvMyJrSg7LqMD/UvTJdPsL+mq4g=";
  };

  patches = [ ./fix_version_check.patch ];

  propagatedBuildInputs = [
    ppx_inline_test
    ppx_expect
    opam-file-format
  ];

  doCheck = true;

  meta = {
    description = "Compatibility library for opam-file-format";
    homepage = "https://github.com/OCamlPro/ez_opam_file";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
