{
  stdenv,
  runCommand,
  makeFontsConf,
  dejavu_fonts,
  python,
  plotly,
  pandas,
  kaleido,
}:

runCommand "${kaleido.pname}-tests" {
  nativeBuildInputs = [
    python
    plotly
    pandas
    kaleido
  ];
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ dejavu_fonts ]; };
  # Rendering launches a browser that can't run in the macOS sandbox.
  __noChroot = stdenv.hostPlatform.isDarwin;
} "python3 ${./tests.py}"
