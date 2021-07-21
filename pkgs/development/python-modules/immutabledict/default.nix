{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ylnddj3x1zvak4fp69bk2c56k3zbfgrf2q5jk9kvlj61zrvhgv7";
  };

  # No tests in PyPI archive
  doCheck = false;

  pythonImportsCheck = [ "immutabledict" ];

  meta = with lib; {
    description = "A fork of frozendict, an immutable wrapper around dictionaries.";
    homepage = "https://github.com/corenting/immutabledict";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
