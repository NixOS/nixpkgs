{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, setuptools-scm, rich, pytest-mock }:

buildPythonPackage rec {
  pname = "enrich";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Dpn/V9h/e13vDKeZF+iPuTUaoNUuIo7ji/982FgxX+Q=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ rich ];

  checkInputs = [ pytestCheckHook pytest-mock ];

  pythonImportsCheck = [ "enrich" ];

  meta = with lib; {
    description = "Enrich adds few missing features to the wonderful rich library";
    homepage = "https://github.com/pycontribs/enrich";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
