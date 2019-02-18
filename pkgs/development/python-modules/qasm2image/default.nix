{ lib
, buildPythonPackage
, fetchFromGitHub
, cairocffi
, cairosvg
, cffi
, qiskit
, svgwrite
, colorama
, python
}:

buildPythonPackage rec {
  pname = "qasm2image";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nelimee";
    repo = "qasm2image";
    rev = "2c01756946ba9782973359dbd7bbf6651af6bee5";
    sha256 = "1bnkzv7wrdvrq71dmsqanb3v2hcsxh5zaglfcxm2d9zzpmvb4a2n";
  };

  propagatedBuildInputs = [
    cairocffi
    cairosvg
    cffi
    qiskit
    svgwrite
  ];

  checkInputs = [
    colorama
  ];
  checkPhase = ''
    ${python.interpreter} tests/launch_tests.py
  '';

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A Python module to visualise quantum circuit";
    homepage    = https://github.com/nelimeee/qasm2image;
    license     = lib.licenses.cecill-b;
    maintainers = with lib.maintainers; [
      pandaman
    ];
  };
}
