{
  pkgs,
  toPythonModule,
}:

toPythonModule (
  pkgs.gz-math.override {
    enablePython = true;
  }
)
