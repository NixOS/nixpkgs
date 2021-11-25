{ buildPythonPackage
, fetchPypi
, future
, lib
}:

buildPythonPackage rec {
  pname = "monkeyhex";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2add1f7f1f620be9ccec0618342e6a9e47de50e0d2252628bffd452bfd3762b";
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
