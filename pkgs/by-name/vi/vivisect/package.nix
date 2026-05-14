{ python3Packages }:
with python3Packages;
toPythonApplication (
  vivisect.override {
    # https://github.com/vivisect/vivisect/issues/683
    # gui currently requires qt5 webengine, which has been removed
    # withGui = true;
  }
)
