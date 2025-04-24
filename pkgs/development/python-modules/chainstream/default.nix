{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "chainstream";
  version = "1.0.1";

  pyproject = true;

  nativeBuildInputs = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-302P1BixEmkODm+qTLZwaWLktrlf9cEziQ/TIVfI07c=";
  };

  pythonImportsCheck = [ "chainstream" ];

  meta = with lib; {
    description = "Chain I/O streams together into a single stream";
    homepage = "https://github.com/rrthomas/chainstream";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ cbley ];
  };
}
