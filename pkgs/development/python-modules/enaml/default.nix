{ 
  lib, buildPythonPackage, fetchFromGitHub,
  atom, ply, kiwisolver, qtpy, sip
}:

buildPythonPackage rec {
  pname = "enaml";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = pname;
    rev = version;
    sha256 = "0xvzllkfgcqrq6c01lc1kjxc14457kim5iqv429qhk7ycvffnq0b";
  };

  # Of course it would be better to run the tests,
  # but it runs into a syntax error in byteplay2.py
  # (even though testing on python3...)
  doCheck = false;

  propagatedBuildInputs = [
    atom ply kiwisolver qtpy sip
  ];

  meta = with lib; {
    homepage = https://github.com/frmdstryr/enaml;
    description = "Declarative User Interfaces for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raboof ];
  };
}
