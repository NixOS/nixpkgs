{ srcs, stdenv, fetchFromGitHub, meson, glib, pkg-config, capstone, lzma, libunwind, libelf, libdwarf, ninja, lib }:
stdenv.mkDerivation {
  pname = "frida-gum-unwrapped";
  version = srcs.version;
  src = fetchFromGitHub srcs.frida-gum;

  # Rebase of https://github.com/frida/frida-gum/pull/711
  patches = [
    ./0001-use-libdwarf-0.0-libdwarf-20210528.patch
    ./0002-use-libdwarf-0.1.patch
    ./0003-use-libdwarf-0.2.patch
    ./0004-use-libdwarf-0.3.patch
    ./0005-use-libdwarf-0.4-or-later.patch
  ];

  buildInputs = [
    glib
    capstone
    lzma
    libunwind
    libelf
    libdwarf
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  meta = with lib; {
    description = "Cross-platform instrumentation and introspection library written in C";
    homepage = "https://github.com/frida/frida-gum";
    license = licenses.wxWindows;
    maintainers = with lib.maintainers; [ lf- ];
    platforms = platforms.unix;
  };
}
