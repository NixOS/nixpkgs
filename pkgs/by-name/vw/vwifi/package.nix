{
  lib,
  stdenv,
  fetchFromGitHub,
  libnl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "vwifi";
  version = "6.3-unstable-2025-01-20";

  src = fetchFromGitHub {
    owner = "Raizo62";
    repo = "vwifi";
    rev = "f8f29b02f786f59f90309947d5b4b23e7d6e8cc7";
    hash = "sha256-FrIgw0MczaCJtPyqcjP3B3Qa6mD9KEJCRQ5QsbD8tgw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnl ];

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR=$(out)"
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man/man1"
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString ([ "-I${libnl.dev}/include/libnl3" ]);
  };

  # Remove root check from Makefile
  postPatch = ''
    substituteInPlace Makefile \
      --replace 'ifneq ($(EUID),0)' 'ifneq (1,1)' \
      --replace '$(DESTDIR)/usr/local/bin' '$(BINDIR)' \
      --replace '$(DESTDIR)/usr/local/man/man1' '$(MANDIR)'
  '';

  meta = with lib; {
    description = "Simulate Wi-Fi (802.11) between Linux Virtual Machines";
    homepage = "https://github.com/Raizo62/vwifi";
    license = licenses.lgpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
