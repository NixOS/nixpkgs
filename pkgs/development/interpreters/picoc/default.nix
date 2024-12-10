{
  lib,
  stdenv,
  fetchFromGitLab,
  readline,
}:

stdenv.mkDerivation {
  pname = "picoc";
  version = "2.1-unstable-2018-06-05";

  src = fetchFromGitLab {
    owner = "zsaleeba";
    repo = "picoc";
    rev = "dc85a51e9211cfb644f0a85ea9546e15dc1141c3";
    hash = "sha256-yWPRbJLT09E7pqqs9E2k48ECoRR2nhcgTgK5pumkrxo=";
  };

  buildInputs = [ readline ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  enableParallelBuilding = true;

  # Tests are currently broken on i686 see
  # https://hydra.nixos.org/build/24003763/nixlog/1
  doCheck = !stdenv.isi686 && !stdenv.isAarch64;
  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    install -Dm755 picoc $out/bin/picoc

    mkdir -p $out/include
    install -m644 *.h $out/include

    runHook postInstall
  '';

  meta = with lib; {
    description = "Very small C interpreter for scripting";
    mainProgram = "picoc";
    longDescription = ''
      PicoC is a very small C interpreter for scripting. It was originally
      written as a script language for a UAV's on-board flight system. It's
      also very suitable for other robotic, embedded and non-embedded
      applications. The core C source code is around 3500 lines of code. It's
      not intended to be a complete implementation of ISO C but it has all the
      essentials. When compiled it only takes a few k of code space and is also
      very sparing of data space. This means it can work well in small embedded
      devices.
    '';
    homepage = "https://gitlab.com/zsaleeba/picoc";
    downloadPage = "https://code.google.com/p/picoc/downloads/list";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
