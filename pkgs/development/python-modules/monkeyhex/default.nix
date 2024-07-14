{
  buildPythonPackage,
  fetchPypi,
  future,
  lib,
}:

buildPythonPackage rec {
  pname = "monkeyhex";
  version = "1.7.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pkYJbdMRTuinxvMDY/OMKI7FbE4DLI/H5oF5K2BN0SI=";
  };

  propagatedBuildInputs = [ future ];

  # No tests in repo.
  doCheck = false;

  # Verify import still works.
  pythonImportsCheck = [ "monkeyhex" ];

  meta = with lib; {
    description = "Small library to assist users of the python shell who work in contexts where printed numbers are more usefully viewed in hexadecimal";
    homepage = "https://github.com/rhelmot/monkeyhex";
    license = licenses.mit;
    maintainers = [ maintainers.pamplemousse ];
  };
}
