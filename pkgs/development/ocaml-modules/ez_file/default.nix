{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  re,
  ocplib_stuff,
  ppx_expect,
}:

buildDunePackage (finalAttrs: {
  pname = "ez_file";
  version = "0.5.0";

  minimalOCamlVersion = "4.11";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ez_file";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lhnx2Co2qx4mPn9U1AXJpXJY5SgMQC1VtCxeN4bcK1w=";
  };

  propagatedBuildInputs = [
    re
    ocplib_stuff
    ppx_expect
  ];

  doCheck = true;

  meta = {
    description = "Library with helpers to manipulate files, read/write their content, search directories, etc";
    homepage = "https://github.com/OCamlPro/ez_file";
    license = lib.licenses.WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
