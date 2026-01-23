{
  lib,
  buildPythonPackage,
  libgdstk,

  # build-system
  build,
  scikit-build-core,

  # deps
  numpy,
  typing-extensions,

  # deps (optional)
  matplotlib,
  sphinx,
  sphinx-inline-tabs,
  sphinx-rtd-theme,

  # build-time
  cmake,
  ninja,

  # run-time
  zlib,
  qhull,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "gdstk";
  inherit (libgdstk) src version;

  pyproject = true;
  strictDeps = true;

  # scikit is supposed to handle the module build
  dontUseCmakeConfigure = true;

  build-system = [
    build
    cmake
    ninja
    numpy
    scikit-build-core
  ];

  dependencies = [
    numpy
    typing-extensions
  ];

  optional-dependencies = {
    docs = [
      matplotlib
      sphinx
      sphinx-inline-tabs
      sphinx-rtd-theme
    ];
  };

  buildInputs = [
    zlib
    qhull
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # remove the `gdstk` source directory, else pytest will attempt to import it
  # instead of the actual module
  preCheck = ''
    rm -rf gdstk
  '';

  pythonImportsCheck = [
    "gdstk"
  ];

  meta = {
    inherit (libgdstk.meta)
      description
      homepage
      changelog
      license
      maintainers
      teams
      ;
  };
}
