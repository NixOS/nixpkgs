{ buildPythonPackage
, fetchPypi
, future
, lib
}:

buildPythonPackage rec {
  pname = "monkeyhex";
  version = "1.7.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a646096dd3114ee8a7c6f30363f38c288ec56c4e032c8fc7e681792b604dd122";
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
