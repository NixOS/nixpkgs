{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "frozen";
  # pin to a newer release if frozen releases again, see cesanta/frozen#72
  version = "unstable-2021-02-23";

  src = fetchFromGitHub {
    owner = "cesanta";
    repo = "frozen";
    rev = "21f051e3abc2240d9a25b2add6629b38e963e102";
    hash = "sha256-BpuYK9fbWSpeF8iPT8ImrV3CKKaA5RQ2W0ZQ03TciR0=";
  };

  nativeBuildInputs = [ meson ninja ];

  # frozen has a simple Makefile and a GN BUILD file as building scripts.
  # Since it has only two source files, the best course of action to support
  # cross compilation is to create a small meson.build file.
  # Relevant upstream issue: https://github.com/cesanta/frozen/pull/71
  preConfigure = ''
    cp ${./meson.build} meson.build
  '';

  meta = {
    homepage = "https://github.com/cesanta/frozen";
    description = "Minimal JSON parser for C, targeted for embedded systems";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thillux ];
    platforms = lib.platforms.unix;
  };
}
