{ lib
, stdenv
, fetchFromGitHub
, validatePkgConfig
}:

stdenv.mkDerivation {
  pname = "linenoise";
  version = "1.0-34-g93b2db9";

  src = fetchFromGitHub {
    owner = "antirez";
    repo = "linenoise";
    rev = "1.0-34-g93b2db9";
    hash = "sha256-GsrYg16gpjHkkmpCU3yGzqNS/buZl+JoWALLvwzmT4A=";
  };

  nativeBuildInputs = [ validatePkgConfig ];

  buildPhase = ''
    runHook preBuild

    $CC -c -o linenoise.o linenoise.c
    $CC -shared -o liblinenoise.so linenoise.o
    $AR rcs liblinenoise.a linenoise.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/lib/pkgconfig $out/include
    install -m644 linenoise.h     $out/include/
    install -m644 liblinenoise.a  $out/lib/
    install -m644 liblinenoise.so $out/lib/
    substituteAll ${./linenoise.pc.in} $out/lib/pkgconfig/linenoise.pc

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/antirez/linenoise";
    description = "A minimal, zero-config, BSD licensed, readline replacement";
    maintainers = with lib.maintainers; [ fstamour remexre ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
}
