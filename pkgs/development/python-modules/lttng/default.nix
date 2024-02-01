{ toPythonModule
, python
, lttng-tools
, swig2
}:

toPythonModule (lttng-tools.overrideAttrs ({ nativeBuildInputs ? [ ], configureFlags ? [ ], ... }: {
  pname = "lttng";

  nativeBuildInputs = nativeBuildInputs ++ [ swig2 ];

  configureFlags = configureFlags ++ [
    "--enable-python-bindings"
    # "--disable-bin-lttng" # The Python bindings depend on liblttng-ctl, which is only built when the binary is enabled.
    "--disable-bin-lttng-consumerd"
    "--disable-bin-lttng-crash"
    "--disable-bin-lttng-relayd"
    "--disable-bin-lttng-sessiond"
    # "--disable-extras" # The Python bindings are an extra.
    "--disable-man-pages"
  ];

  PYTHON = "${python.pythonOnBuildForHost}/bin/python";
  PYTHON_CONFIG = "${python.pythonOnBuildForHost}/bin/python-config";
}))
