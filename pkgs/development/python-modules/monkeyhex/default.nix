{ buildPythonPackage
, fetchPypi
, future
, lib
}:

buildPythonPackage rec {
  pname = "monkeyhex";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c121e734ccae8f1be6f1ecaf9100f3f8bde0a2dd03979b8ba42c474b1978806e";
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
