{
  stdenv,
  lib,
  pandoc,
  typst,
  esbuild,
  deno,
  fetchurl,
  dart-sass,
  rWrapper,
  rPackages,
  extraRPackages ? [ ],
  makeWrapper,
  runCommand,
  python3,
  quarto,
  extraPythonPackages ? ps: [ ],
  sysctl,
  which,
}:

let
  rWithPackages = rWrapper.override {
    packages = [
      rPackages.rmarkdown
    ] ++ extraRPackages;
  };

  pythonWithPackages = python3.withPackages (
    ps:
    with ps;
    [
      jupyter
      ipython
    ]
    ++ (extraPythonPackages ps)
  );
in
stdenv.mkDerivation (final: {
  pname = "quarto";
  version = "1.7.31";

  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${final.version}/quarto-${final.version}-linux-amd64.tar.gz";
    hash = "sha256-YRSe4MLcJCaqBDGwHiYxOxAGFcehZLIVCkXjTE0ezFc=";
  };

  patches = [
    ./deno2.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    which
  ];

  dontStrip = true;

  preFixup = ''
    wrapProgram $out/bin/quarto \
      --set QUARTO_DENO ${lib.getExe deno} \
      --set QUARTO_PANDOC ${lib.getExe pandoc} \
      --set QUARTO_ESBUILD ${lib.getExe esbuild} \
      --set QUARTO_DART_SASS ${lib.getExe dart-sass} \
      --set QUARTO_TYPST ${lib.getExe typst} \
      ${lib.optionalString (rWrapper != null) "--set QUARTO_R ${rWithPackages}/bin/R"} \
      ${lib.optionalString (python3 != null) "--set QUARTO_PYTHON ${pythonWithPackages}/bin/python3"}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    rm -r bin/tools

    mv bin/* $out/bin
    mv share/* $out/share

    runHook postInstall
  '';

  passthru.tests = {
    quarto-check =
      runCommand "quarto-check"
        {
          nativeBuildInputs = [ which ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sysctl ];
        }
        ''
          export HOME="$(mktemp -d)"
          ${quarto}/bin/quarto check
          touch $out
        '';
  };

  meta = with lib; {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    mainProgram = "quarto";
    longDescription = ''
      Quarto is an open-source scientific and technical publishing system built on Pandoc.
      Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      minijackson
      mrtarantoga
    ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
