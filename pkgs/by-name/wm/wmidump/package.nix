{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "wmidump";
  version = "0-unstable-2026-03-13";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "iksaif";
    repo = "wmidump";
    rev = "9c3109cb9b24b8b989bc57ba829d5b1c48b82a96";
    hash = "sha256-MQySsGxvCYOaiuNzjlkhafLu3EawqOvfewSmIR0zBeM=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Dump WMI informations from ACPI tables";
    license = lib.licenses.gpl2Plus;
    mainProgram = "wmidump";
    homepage = "https://github.com/iksaif/wmidump";
    maintainers = [ lib.maintainers.nikableh ];
  };
}
