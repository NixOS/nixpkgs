{ lib, stdenv, fetchFromGitHub
, python3
}:

stdenv.mkDerivation {
  pname   = "libinjection";
  version = "unstable-2021-04-09";

  src = fetchFromGitHub {
    owner = "libinjection";
    repo  = "libinjection";
    rev   = "49904c42a6e68dc8f16c022c693e897e4010a06c";
    hash  = "sha256-Y6ZPxjJUBn2P5UdejJdUuBvrSHaUoIs3lZo14gCB16Y=";
  };

  nativeBuildInputs = [ python3 ];

  strictDeps = true;

  patchPhase = ''
    patchShebangs src
    substituteInPlace src/Makefile \
      --replace /usr/local $out
  '';

  configurePhase = "cd src";
  buildPhase = "make all";

  # no binaries, so out = library, dev = headers
  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "SQL / SQLI tokenizer parser analyzer";
    homepage    = "https://github.com/client9/libinjection";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
