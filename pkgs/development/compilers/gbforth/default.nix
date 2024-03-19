{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, gforth
}:

stdenv.mkDerivation {
  pname = "gbforth";
  version = "unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "ams-hackers";
    repo = "gbforth";
    rev = "428fcf5054fe301e90ac74b1d920ee3ecc375b5b";
    hash = "sha256-v1bdwT15Wg1VKpo74Cc3tsTl1uOKvKdlHWtbZkJ/qbA=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gbforth $out/bin
    cp -r lib shared src gbforth.fs $out/share/gbforth/
    makeWrapper ${gforth}/bin/gforth $out/bin/gbforth \
      --set GBFORTH_PATH $out/share/gbforth/lib \
      --add-flags $out/share/gbforth/gbforth.fs
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/gbforth examples/simon/simon.fs
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://gbforth.org/";
    description = "A Forth-based Game Boy development kit";
    mainProgram = "gbforth";
    longDescription = ''
      A Forth-based Game Boy development kit.
      It features a Forth-based assembler, a cross-compiler with support for
      lazy code generation and a library of useful words.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
