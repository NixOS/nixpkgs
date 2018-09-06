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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "nelimeee";
    repo = "qasm2image";
    rev = "57a640621bbbc74244f07e2e068a26411b0d9b24";
    sha256 = "1ha5vfl4jfwcwbipsq07xlknkrvx79z5bwbzndybclyk9pa69dlz";
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
