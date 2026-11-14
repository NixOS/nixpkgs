{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  stdenv,
}:

# 6.x reworks the API around figure objects and drops the module-level global
# state that `textual-plotext` (and therefore `fumis`) still relies on, so it is
# kept out of the default `plotext` attribute until that is resolved upstream.
buildPythonPackage rec {
  pname = "plotext";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piccolomo";
    repo = "plotext";
    tag = version;
    hash = "sha256-K8OSufoYsQmjeBDtpxtYuNGipWF1FM53EoGNolsgVmQ=";
  };

  build-system = [ setuptools ];

  # `build_cpp.py` compiles the drawing kernel with plain `g++`, and the result
  # links against libstdc++.
  buildInputs = [ stdenv.cc.cc.lib ];

  doCheck = false;

  pythonImportsCheck = [ "plotext" ];

  meta = {
    description = "Plotting directly in the terminal";
    mainProgram = "plotext";
    homepage = "https://github.com/piccolomo/plotext";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
