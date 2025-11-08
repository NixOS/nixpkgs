{
  toPythonModule,
  pkgs,
  python,
}:
toPythonModule (
  pkgs.nlopt.override {
    withPython = true;
    python3 = python;
    python3Packages = python.pkgs;
  }
)
