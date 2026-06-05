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
    pandas
    kaleido
  ];
} "python3 ${./tests.py}"
