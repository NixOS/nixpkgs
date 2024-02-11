{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ck";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "concurrencykit";
    repo = pname;
    rev = version;
    sha256 = "sha256-HUC+8Vd0koAmumRZ8gS5u6LVa7fUfkIYRaxVv6/7Hgg=";
  };

  postPatch = ''
    substituteInPlace \
      configure \
        --replace \
          'COMPILER=`./.1 2> /dev/null`' \
          "COMPILER=gcc"
  '';

  configureFlags = ["--platform=${stdenv.hostPlatform.parsed.cpu.name}}"];

  dontDisableStatic = true;

  meta = with lib; {
    description = "High-performance concurrency research library";
    longDescription = ''
      Concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures for the research, design and implementation of high performance concurrent systems.
    '';
    license = with licenses; [ asl20 bsd2 ];
    homepage = "http://concurrencykit.org/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ chessai thoughtpolice ];
  };
}
