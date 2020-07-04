{ lib, buildPythonPackage, fetchPypi, poetry, pytest }:

buildPythonPackage rec {
  pname = "pastel";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dnaw44ss10i10z4ksy0xljknvjap7rb7g0b8p6yzm5x4g2my5a6";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/sdispater/pastel";
    description = "Bring colors to your terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
