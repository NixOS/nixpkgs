{
  toPythonModule,
  python,
  lttng-tools,
  swig,
}:

toPythonModule (
  lttng-tools.overrideAttrs (
    {
      nativeBuildInputs ? [ ],
      configureFlags ? [ ],
      ...
    }:
    {
      pname = "lttng";

      nativeBuildInputs = nativeBuildInputs ++ [ swig ];

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

      # Nix treats nativeBuildInputs specially for cross-compilation, but in this
      # case, cross-compilation is accounted for explicitly. Using the variables
      # ensures that the platform setup isn't messed with further. It also allows
      # regular Python to be added in the future if it is ever needed.
      PYTHON = "${python.pythonOnBuildForHost}/bin/python";
      PYTHON_CONFIG = "${python.pythonOnBuildForHost}/bin/python-config";
    }
  )
)
