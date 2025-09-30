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
    ]
    ++ extraRPackages;
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
  version = "1.7.34";

  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${final.version}/quarto-${final.version}-linux-amd64.tar.gz";
    hash = "sha256-3WsDCkS5Y9AflLlpa6y6ca/DF4621RqcwQUzK3fqa5o=";
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
      --set-default QUARTO_DENO ${lib.getExe deno} \
      --set-default QUARTO_PANDOC ${lib.getExe pandoc} \
      --set-default QUARTO_ESBUILD ${lib.getExe esbuild} \
      --set-default QUARTO_DART_SASS ${lib.getExe dart-sass} \
      --set-default QUARTO_TYPST ${lib.getExe typst} \
      ${lib.optionalString (rWrapper != null) "--set-default QUARTO_R ${rWithPackages}/bin/R"} \
      ${lib.optionalString (
        python3 != null
      ) "--set-default QUARTO_PYTHON ${pythonWithPackages}/bin/python3"}
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

  meta = {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    mainProgram = "quarto";
    longDescription = ''
      Quarto is an open-source scientific and technical publishing system built on Pandoc.
      Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${final.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      minijackson
      mrtarantoga
    ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
