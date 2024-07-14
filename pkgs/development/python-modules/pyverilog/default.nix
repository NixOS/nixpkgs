{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  jinja2,
  ply,
  verilog,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyverilog";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wdk+kATr6ecT4v1ql4Sgni1rPAmAkf02d5XrIDKa5Kg=";
  };

  disabled = pythonOlder "3.7";

  patchPhase = ''
    # The path to Icarus can still be overridden via an environment variable at runtime.
    substituteInPlace pyverilog/vparser/preprocessor.py \
      --replace "iverilog = 'iverilog'" "iverilog = '${verilog}/bin/iverilog'"
  '';

  propagatedBuildInputs = [
    jinja2
    ply
    verilog
  ];

  preCheck = ''
    substituteInPlace pytest.ini \
      --replace "python_paths" "pythonpath"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/PyHDI/Pyverilog";
    description = "Python-based Hardware Design Processing Toolkit for Verilog HDL";
    license = licenses.asl20;
    maintainers = with maintainers; [ trepetti ];
  };
}
