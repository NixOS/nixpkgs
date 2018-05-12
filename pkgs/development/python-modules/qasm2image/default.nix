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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nelimeee";
    repo = "qasm2image";
    rev = "7f3c3e4d1701b8b284ef0352aa3a47722ebbbcaa";
    sha256 = "129xlpwp36h2czzw1wcl8df2864zg3if2gaad1v18ah1cf68b0f3";
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

  meta = {
    description = "A Python module to visualise quantum circuit";
    homepage    = https://github.com/nelimeee/qasm2image;
    license     = lib.licenses.cecill-b;
    maintainers = with lib.maintainers; [
      pandaman
    ];
  };
}
