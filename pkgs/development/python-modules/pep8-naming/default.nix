{ lib, fetchPypi, buildPythonPackage
, flake8-polyfill }:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aff4g3i2z08cx7z17nbxbf32ddrnvqlk16h6d8h9s9w5ymivjq1";
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
