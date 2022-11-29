{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-runner
, pytest
, pytest-asyncio
, sqlalchemy
, isPy27
}:

buildPythonPackage rec {
  pname = "aiocontextvars";
  version = "0.2.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "fantix";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a2gmrm9csiknc8n3si67sgzffkydplh9d7ga1k87ygk2aj22mmk";
  };

  buildInputs = [
    pytest-runner
  ];

  checkInputs = [
    pytest
    pytest-asyncio
  ];

  propagatedBuildInputs = [
    sqlalchemy

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Asyncio support for PEP-567 contextvars backport";
    homepage = "https://github.com/fantix/aiocontextvars";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
