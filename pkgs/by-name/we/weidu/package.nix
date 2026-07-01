{
  stdenv,
  lib,
  fetchFromGitHub,
  versionCheckHook,
  elkhound,
  ocaml-ng,
  perl,
  which,
}:

let
  # 1. Needs ocaml >= 4.04 and <= 4.11 but works with 4.14 when patched
  # 2. ocaml 4.10+ defaults to safe (immutable) strings so we need a version with
  #    that disabled as weidu is strongly dependent on mutable strings
  ocaml' = ocaml-ng.ocamlPackages_4_14_unsafe_string.ocaml;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "weidu";
  version = "251";

  src = fetchFromGitHub {
    owner = "WeiDUorg";
    repo = "weidu";
    rev = "v${finalAttrs.version}.00";
    sha256 = "sha256-oVQYESBqp0fJ+ECLGQOPCECnDpGMR8U5ijvTVPc8z4g=";
  };

  postPatch = ''
    substituteInPlace Configuration \
      --replace-fail ' = elkhound' ' = ${lib.getExe elkhound}'

    mkdir -p obj/{.depend,x86_LINUX}
  '';

  nativeBuildInputs = [
    elkhound
    ocaml'
    perl
    versionCheckHook
    which
  ];

  buildFlags = [
    "weidu"
    "weinstall"
    "tolower"
  ];

  installPhase = ''
    runHook preInstall

    for b in tolower weidu weinstall; do
      install -Dm555 $b.asm.exe $out/bin/$b
    done

    install -Dm444 -t $out/share/doc/weidu README* COPYING

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = {
    description = "InfinityEngine Modding Engine";
    homepage = "https://weidu.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    # should work fine on Windows
    platforms = lib.platforms.unix;
    mainProgram = "weidu";
  };
})
