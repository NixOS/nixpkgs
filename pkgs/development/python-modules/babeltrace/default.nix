{ toPythonModule
, python
, babeltrace
, swig2
}:

toPythonModule (babeltrace.overrideAttrs ({ nativeBuildInputs ? [ ], configureFlags ? [ ], ... }: {
  nativeBuildInputs = nativeBuildInputs ++ [ swig2 ];

  configureFlags = configureFlags ++ [ "--enable-python-bindings" ];

  PYTHON = "${python.pythonOnBuildForHost}/bin/python";
  PYTHON_CONFIG = "${python.pythonOnBuildForHost}/bin/python-config";
}))
