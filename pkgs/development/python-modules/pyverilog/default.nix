{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jinja2,
  ply,
  iverilog,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyverilog";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wdk+kATr6ecT4v1ql4Sgni1rPAmAkf02d5XrIDKa5Kg=";
  };

  patchPhase = ''
    # The path to Icarus can still be overridden via an environment variable at runtime.
    substituteInPlace pyverilog/vparser/preprocessor.py \
      --replace-fail \
        "iverilog = 'iverilog'" \
        "iverilog = '${lib.getExe' iverilog "iverilog"}'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    ply
    iverilog
  ];

  preCheck = ''
    substituteInPlace pytest.ini \
      --replace-fail "python_paths" "pythonpath"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/PyHDI/Pyverilog";
    description = "Python-based Hardware Design Processing Toolkit for Verilog HDL";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
