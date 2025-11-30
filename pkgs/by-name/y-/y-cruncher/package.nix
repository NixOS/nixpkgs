{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "y-cruncher";
  version = "0.8.7.9547";

  src = fetchurl {
    url = "https://github.com/Mysticial/y-cruncher/releases/download/v${finalAttrs.version}/y-cruncher.v${finalAttrs.version}-static.tar.xz";
    hash = "sha256-4i/zRPQnY1INIzHxntYXfzp8eKxb1GLpwGDDgmcYFJA=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 y-cruncher -t $out/lib/y-cruncher/
    install -Dm755 Binaries/*~* -t $out/lib/y-cruncher/Binaries/
    install -Dm644 Binaries/Digits/*.txt -t $out/lib/y-cruncher/Binaries/Digits/
    install -Dm644 Custom\ Formulas/*.cfg -t $out/lib/y-cruncher/Custom\ Formulas/
    makeWrapper $out/lib/y-cruncher/y-cruncher $out/bin/y-cruncher

    install -Dm644 "Command Lines.txt" -t $out/share/doc/y-cruncher/
    install -Dm644 "Read Me.txt" -t $out/share/doc/y-cruncher/
    install -Dm644 "Username.txt" -t $out/share/doc/y-cruncher/
    install -Dm644 Binaries/*.txt -t $out/share/doc/y-cruncher/
    install -Dm644 Custom\ Formulas/#README.txt -t $out/share/doc/y-cruncher/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Compute Pi and other constants to billions of digits";
    longDescription = ''
      How fast can your computer compute Pi?

      y-cruncher is a program that can compute Pi and other constants
      to trillions of digits.

      It is the first of its kind that is multi-threaded and scalable
      to multi-core systems. Ever since its launch in 2009, it has
      become a common benchmarking and stress-testing application for
      overclockers and hardware enthusiasts.

      y-cruncher has been used to set several world records for the
      most digits of Pi ever computed.
    '';
    homepage = "https://www.numberworld.org/y-cruncher/";
    downloadPage = "https://www.numberworld.org/y-cruncher/#Download";
    changelog = "https://www.numberworld.org/y-cruncher/version_history.html";
    license = with lib.licenses; [
      unfree
      asl20 # Apache Commons + HTTP Client
      bsd3 # Intel Cilk Run-Time Library
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "y-cruncher";
    platforms = lib.platforms.linux;
  };
})
