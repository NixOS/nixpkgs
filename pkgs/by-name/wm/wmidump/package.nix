{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "wmidump";
  version = "0-unstable-2021-10-11";

  src = fetchFromGitHub {
    owner = "iksaif";
    repo = "wmidump";
    rev = "ae728927dd5b32d965a25660bb68a4c781eb5103";
    hash = "sha256-BFNZSpa70lzw52qT6+sB3tRUgCq9e1XmVyxh7J+AjQk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    installBin wmidump

    runHook postInstall
  '';

  meta = {
    description = "Dump WMI informations from ACPI tables";
    license = lib.licenses.unfree;
    mainProgram = "wmidump";
    homepage = "https://github.com/iksaif/wmidump";
    maintainers = with lib.maintainers; [ synalice ];
  };
}
