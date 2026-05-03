{
  runCommand,
  python,
  plotly,
  pandas,
  kaleido,
}:

runCommand "${kaleido.pname}-tests" {
  nativeBuildInputs = [
    python
    plotly
    kaleido
    pandas
  ];
} "python3 ${./tests.py}"
