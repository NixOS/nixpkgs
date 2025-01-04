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
  ];
} "python3 ${./tests.py}"
