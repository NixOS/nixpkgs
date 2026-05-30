{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  bash,
  gnuplot,
  gitUpdater,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vtebench";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "vtebench";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2uuH7JTilKC+yVY+sMG0lMzLFzRefqEyM/L5gnMDIJw=";
  };
  cargoHash = "sha256-3PQA5rw5eiqHfQCZPAgN7FF/mPK2YeZd3TT4SCnBp3I=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];
  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = ''
    mkdir -p $out/share/vtebench
    cp -r benchmarks gnuplot{,_summary}.sh -t $out/share/vtebench
  '';

  postFixup = ''
    # The benchmarks and gnuplot helpers are all shell scripts
    patchShebangs $out/share/vtebench

    # vtebench tries to look for the benchmarks in the `benchmarks` folder
    # in the current directory by default, but we patch it here to use
    # the packaged benchmarks instead
    wrapProgram $out/bin/vtebench \
      --add-flags "--benchmarks $out/share/vtebench/benchmarks"

    # Neither gnuplot wrapper script is included with vtebench itself,
    # so we have to make them available as wrapped binaries to avoid users
    # having to obtain them on their own
    makeWrapper $out/share/vtebench/gnuplot.sh $out/bin/vtebench-gnuplot \
      --suffix PATH : ${lib.makeBinPath [ gnuplot ]}
    makeWrapper $out/share/vtebench/gnuplot_summary.sh $out/bin/vtebench-gnuplot-summary \
      --suffix PATH : ${lib.makeBinPath [ gnuplot ]}
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Generate benchmarks for terminal emulators";
    longDescription = ''
      A tool for benchmarking terminal emulator PTY read performance.

      The `vtebench` binary has been patched to use the default benchmarks
      automatically. Run `vtebench-gnuplot` or `vtebench-gnuplot-summary`
      to run the `gnuplot.sh` and `gnuplot_summary.sh` scripts respectively.
    '';
    homepage = "https://github.com/alacritty/vtebench";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      pluiedev
    ];
    mainProgram = "vtebench";
  };
})
