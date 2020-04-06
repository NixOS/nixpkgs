{ buildPythonPackage
, fetchPypi
, future
, lib
}:

buildPythonPackage rec {
  pname = "monkeyhex";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ba913df664c34f3ce53916c83872fddf750adc78a0b0ecdd316ac3e728bb019";
  };

  propagatedBuildInputs = [ future ];

  # No tests in repo.
  doCheck = false;

  # Verify import still works.
  pythonImportsCheck = [ "monkeyhex" ];

  meta = with lib; {
    description = "A small library to assist users of the python shell who work in contexts where printed numbers are more usefully viewed in hexadecimal";
    homepage = "https://github.com/rhelmot/monkeyhex";
    license = licenses.mit;
    maintainers = [ maintainers.pamplemousse ];
  };
}
