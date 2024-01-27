{ stdenv
, lib
, pandoc
, esbuild
, deno
, fetchurl
, dart-sass
, rWrapper
, rPackages
, extraRPackages ? []
, makeWrapper
, runCommand
, python3
, quarto
, extraPythonPackages ? ps: with ps; []
, sysctl
}:

stdenv.mkDerivation (final: {
  pname = "quarto";
  version = "1.4.549";
  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${final.version}/quarto-${final.version}-linux-amd64.tar.gz";
    sha256 = "sha256-YeA9QKdaSzKtgjybVz22IopYICqblflNE8nN8j3Xr3g=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postPatch = ''
    # Compat for Deno >=1.26
    substituteInPlace bin/quarto.js \
      --replace 'Deno.setRaw(stdin.rid, ' 'Deno.stdin.setRaw(' \
      --replace 'Deno.setRaw(Deno.stdin.rid, ' 'Deno.stdin.setRaw(' \
      --replace ']))?.trim();' ']))?.trim().split(" ")[0];'
  '';

  dontStrip = true;

  preFixup = ''
    wrapProgram $out/bin/quarto \
      --prefix QUARTO_DENO : ${deno}/bin/deno \
      --prefix QUARTO_PANDOC : ${pandoc}/bin/pandoc \
      --prefix QUARTO_ESBUILD : ${esbuild}/bin/esbuild \
      --prefix QUARTO_DART_SASS : ${dart-sass}/bin/dart-sass \
      ${lib.optionalString (rWrapper != null) "--prefix QUARTO_R : ${rWrapper.override { packages = [ rPackages.rmarkdown ] ++ extraRPackages; }}/bin/R"} \
      ${lib.optionalString (python3 != null) "--prefix QUARTO_PYTHON : ${python3.withPackages (ps: with ps; [ jupyter ipython ] ++ (extraPythonPackages ps))}/bin/python3"}
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
    quarto-check = runCommand "quarto-check" {
      nativeBuildInputs = lib.optionals stdenv.isDarwin [ sysctl ];
    } ''
      export HOME="$(mktemp -d)"
      ${quarto}/bin/quarto check
      touch $out
    '';
  };

  meta = with lib; {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    longDescription = ''
        Quarto is an open-source scientific and technical publishing system built on Pandoc.
        Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ minijackson mrtarantoga ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
  };
})
