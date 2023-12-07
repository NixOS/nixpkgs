{
  qtModule,
  stdenv,
  qtbase-bootstrap,
  qttools-bootstrap,
  buildPackages,
}:

# I don't want to bother with cross compilation support for qttranslations
# as the outputs are identical with a native-built one. It will require a small
# fiddling with a native-built qtbase-bootstrap in buildInputs (it is there only
# for a few configs in mkspecs) or an additional individual build of qtbase/mkspecs
# just for the sake of this package. There's really just no point in it.
if stdenv.hostPlatform != stdenv.buildPlatform then
  buildPackages.qt5.qttranslations

else
  qtModule {
    pname = "qttranslations";
    buildInputs = [ qtbase-bootstrap.dev ];
    nativeBuildInputs = [ qttools-bootstrap ];
    outputs = [ "out" ];
  }
