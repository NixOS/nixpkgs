{lib, stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20210730";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1pmm977nyl3bs71ipzcl4dh30qm8x9wm2p2ml0m62rl62kai832a";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  buildFlags = [ "iasl" ];

  nativeBuildInputs = [ bison flex ];

  installPhase =
    ''
      runHook preInstall

      install -Dm755 generate/unix/bin*/iasl -t $out/bin

      runHook postInstall
    '';

  meta = {
    description = "Intel ACPI Compiler";
    homepage = "http://www.acpica.org/";
    license = lib.licenses.iasl;
    platforms = lib.platforms.unix;
  };
}
