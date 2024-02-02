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

  PYTHON = "${python.pythonOnBuildForHost}/bin/python";
  PYTHON_CONFIG = "${python.pythonOnBuildForHost}/bin/python-config";
}))
