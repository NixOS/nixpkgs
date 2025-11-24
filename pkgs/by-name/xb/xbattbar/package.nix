{
  lib,
  stdenv,
  fetchgit,
  libX11,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xbattbar";
  version = "1.4.9";

  # The current active upstream of xbattbar seems to be the Debian source
  # repository.
  src = fetchgit {
    url = "https://salsa.debian.org/debian/xbattbar.git";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-ZrJAyDyvlUmNpxBC06yrzBJ7vhrZY4+GbfBDQoF+h4M=";
  };

  buildInputs = [ libX11 ];

  # remove the APM checker binary, make the sys checker
  # script the default. Rationale: checking battery status by /proc/apm is
  # extremely oldschool and does not work on NixOS, while the sysfs script
  # does.
  patches = [ ./sys-by-default.patch ];
  # - perl shebang patches for acpi/sys scripts
  # - unhardcode path to checker scripts
  # - add missing return type in main function
  postPatch = ''
    substituteInPlace xbattbar.c \
      --replace-fail "main(int argc" "int main(int argc"

    sed -i -e "s,/usr/lib/xbattbar/,$out/libexec/," xbattbar.c
    sed -i -e "s,/usr/bin/perl,${perl}/bin/perl," xbattbar-check-acpi
    sed -i -e "s,/usr/bin/perl,${perl}/bin/perl," xbattbar-check-sys
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,libexec}

    install -m 0755 xbattbar $out/bin/
    install -m 0755 xbattbar-check-acpi $out/libexec/
    install -m 0755 xbattbar-check-sys $out/libexec/

    runHook postInstall
  '';

  meta = {
    description = "Display battery status in X11";
    homepage = "https://salsa.debian.org/debian/xbattbar";
    license = with lib; licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ q3k ];
    mainProgram = "xbattbar";
  };
})
