{ lib, fetchPypi, buildPythonPackage
, flake8-polyfill }:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a33d38177056321a167decd6ba70b890856ba5025f0a8eca6a3eda607da93caf";
  };

  propagatedBuildInputs = [
    flake8-polyfill
  ];

  meta = with lib; {
    homepage = https://github.com/PyCQA/pep8-naming;
    description = "Check PEP-8 naming conventions, plugin for flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
