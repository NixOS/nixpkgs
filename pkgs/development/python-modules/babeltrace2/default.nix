{ toPythonModule
, python
, babeltrace2
, swig
}:

toPythonModule (babeltrace2.overrideAttrs ({ nativeBuildInputs ? [ ], configureFlags ? [ ], ... }: {
  nativeBuildInputs = nativeBuildInputs ++ [ swig ];

  configureFlags = configureFlags ++ [
    "--enable-python-bindings"
    "--enable-python-plugins"
  ];

  # Nix treats nativeBuildInputs specially for cross-compilation, but in this
  # case, cross-compilation is accounted for explicitly. Using the variables
  # ensures that the platform setup isn't messed with further. It also allows
  # regular Python to be added in the future if it is ever needed.
  PYTHON = "${python.pythonOnBuildForHost}/bin/python";
  PYTHON_CONFIG = "${python.pythonOnBuildForHost}/bin/python-config";
}))
