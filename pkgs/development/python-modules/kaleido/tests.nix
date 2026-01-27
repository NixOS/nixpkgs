{
  runCommand,
  python,
  kaleido,
}:

# NOTE: This prints warnings:
#     /nix/store/...-tests.py:11: DeprecationWarning:
#     Support for Kaleido versions less than 1.0.0 is deprecated and will be removed after September 2025.
#     Please upgrade Kaleido to version 1.0.0 or greater (`pip install 'kaleido>=1.0.0'` or `pip install 'plotly[kaleido]'`).
runCommand "${kaleido.pname}-tests" {
  nativeBuildInputs = [
    (python.withPackages (pyPkgs: [
      pyPkgs.plotly
      pyPkgs.pandas
      pyPkgs.kaleido
    ]))
  ];
} "python3 ${./tests.py}"
