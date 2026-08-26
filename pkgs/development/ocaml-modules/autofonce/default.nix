{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_expect,
  ppx_inline_test,
  ocplib_stuff,
  ez_file,
  ez_cmdliner,
  ansiterminal,
  crunch,
  toml,
}:

buildDunePackage (finalAttrs: {
  pname = "autofonce";
  version = "0.9-unstable-2026-06-25";

  minimalOCamlVersion = "4.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "autofonce";
    rev = "36c577b642ba5355e5a448ccef62a973fadd1eb6";
    hash = "sha256-mdnPBFN57aYglcIKHlYEwzBLh97yJVIrzS0JJTIC0lI=";
  };

  nativeBuildInputs = [
    crunch
  ];

  propagatedBuildInputs = [
    ppx_expect
    ppx_inline_test
    ocplib_stuff
    ez_file
    ez_cmdliner
    ansiterminal
    toml
  ];

  dunePackages = [
    "autofonce"
    "autofonce_core"
    "autofonce_lib"
    "autofonce_m4"
    "autofonce_share"
    "autofonce_patch"
    "autofonce_config"
    "autofonce_misc"
    "ez_win32"
    "ez_call"
  ];

  doCheck = true;

  meta = {
    description = "Modern runner for GNU Autoconf testsuites in m4";
    homepage = "https://ocamlpro.github.io/autofonce/sphinx/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    mainProgram = "autofonce";
  };
})
