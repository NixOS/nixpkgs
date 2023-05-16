{ stdenv
, lib
, pandoc
, esbuild
, deno
, fetchurl
<<<<<<< HEAD
, dart-sass
=======
, nodePackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rWrapper
, rPackages
, extraRPackages ? []
, makeWrapper
<<<<<<< HEAD
, runCommand
, python3
, quarto
, extraPythonPackages ? ps: with ps; []
}:

stdenv.mkDerivation (final: {
  pname = "quarto";
  version = "1.3.450";
  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${final.version}/quarto-${final.version}-linux-amd64.tar.gz";
    sha256 = "sha256-bcj7SzEGfQxsw9P8WkcLrKurPupzwpgIGtxoE3KVwAU=";
=======
, python3
, extraPythonPackages ? ps: with ps; []
}:

stdenv.mkDerivation rec {
  pname = "quarto";
  version = "1.2.475";
  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${version}/quarto-${version}-linux-amd64.tar.gz";
    sha256 = "sha256-oyKjDlTKt2fIzirOqgNRrpuM7buNCG5mmgIztPa28rY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  patches = [
    ./fix-deno-path.patch
  ];

  postPatch = ''
    # Compat for Deno >=1.26
    substituteInPlace bin/quarto.js \
      --replace 'Deno.setRaw(stdin.rid, ' 'Deno.stdin.setRaw(' \
      --replace 'Deno.setRaw(Deno.stdin.rid, ' 'Deno.stdin.setRaw('
  '';

  dontStrip = true;

  preFixup = ''
    wrapProgram $out/bin/quarto \
      --prefix PATH : ${lib.makeBinPath [ deno ]} \
      --prefix QUARTO_PANDOC : ${pandoc}/bin/pandoc \
      --prefix QUARTO_ESBUILD : ${esbuild}/bin/esbuild \
<<<<<<< HEAD
      --prefix QUARTO_DART_SASS : ${dart-sass}/bin/dart-sass \
      ${lib.optionalString (rWrapper != null) "--prefix QUARTO_R : ${rWrapper.override { packages = [ rPackages.rmarkdown ] ++ extraRPackages; }}/bin/R"} \
      ${lib.optionalString (python3 != null) "--prefix QUARTO_PYTHON : ${python3.withPackages (ps: with ps; [ jupyter ipython ] ++ (extraPythonPackages ps))}/bin/python3"}
=======
      --prefix QUARTO_DART_SASS : ${nodePackages.sass}/bin/sass \
      --prefix QUARTO_R : ${rWrapper.override { packages = [ rPackages.rmarkdown ] ++ extraRPackages; }}/bin/R \
      --prefix QUARTO_PYTHON : ${python3.withPackages (ps: with ps; [ jupyter ipython ] ++ (extraPythonPackages ps))}/bin/python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share

      rm -r bin/tools

      mv bin/* $out/bin
      mv share/* $out/share

      runHook preInstall
  '';

<<<<<<< HEAD
  passthru.tests = {
    quarto-check = runCommand "quarto-check" {} ''
      export HOME="$(mktemp -d)"
      ${quarto}/bin/quarto check
      touch $out
    '';
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    longDescription = ''
        Quarto is an open-source scientific and technical publishing system built on Pandoc.
        Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${version}";
    license = licenses.gpl2Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ minijackson mrtarantoga ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
  };
})
=======
    maintainers = with maintainers; [ mrtarantoga ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
