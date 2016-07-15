{ stdenv, fetchFromGitHub, zlib, jdk }:

stdenv.mkDerivation rec {
  name = "avian-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "readytalk";
    repo = "avian";
    rev = "v${version}";
    sha256 = "1j2y45cpqk3x6a743mgpg7z3ivwm7qc9jy6xirvay7ah1qyxmm48";
  };

  buildInputs = [
    zlib
    jdk
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/*/avian $out/bin/
    cp build/*/avian-dynamic $out/bin/
  '';

  meta = {
    description = "Lightweight Java virtual machine";
    longDescription = ''
      Avian is a lightweight virtual machine and class library designed
      to provide a useful subset of Java’s features, suitable for
      building self-contained applications.
    '';
    homepage = https://readytalk.github.io/avian/;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.all;
  };
}
