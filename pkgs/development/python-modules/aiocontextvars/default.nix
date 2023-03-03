{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-runner
, pytestCheckHook
, pytest-asyncio
, sqlalchemy
, isPy27
}:

buildPythonPackage rec {
  pname = "aiocontextvars";
  version = "0.2.2";
  format = "setuptools";
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

  propagatedBuildInputs = [
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Asyncio support for PEP-567 contextvars backport";
    homepage = "https://github.com/fantix/aiocontextvars";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
