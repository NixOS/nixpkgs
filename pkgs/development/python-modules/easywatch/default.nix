{
  lib,
  fetchPypi,
  buildPythonPackage,
  watchdog,
}:

buildPythonPackage rec {
  pname = "easywatch";
  version = "0.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DN7XAQYIPq3m4y9m7vH5QAywOfTG9w6RxEmf/aJkgKw=";
  };

  propagatedBuildInputs = [ watchdog ];

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [ "easywatch" ];

  meta = with lib; {
    description = "Dead-simple way to watch a directory";
    homepage = "https://github.com/Ceasar/easywatch";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
