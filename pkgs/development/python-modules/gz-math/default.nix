{
  pkgs,
  toPythonModule,
}:

toPythonModule (
  pkgs.gz-math.override {
    withPython = true;
  }
)
