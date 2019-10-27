{ stdenv, fetchFromGitHub, zlib, jdk, CoreServices, Foundation }:

stdenv.mkDerivation rec {
  pname = "avian";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "readytalk";
    repo = "avian";
    rev = "v${version}";
    sha256 = "1j2y45cpqk3x6a743mgpg7z3ivwm7qc9jy6xirvay7ah1qyxmm48";
  };

  buildInputs = [ zlib jdk ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Foundation ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  postPatch = ''
    substituteInPlace makefile \
        --replace 'g++' 'c++' \
        --replace 'gcc' 'cc'
  '';

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
    maintainers = [ stdenv.lib.maintainers.earldouglas ];
  };
}
