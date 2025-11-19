{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  psycopg2,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiopg";
  version = "1.5.0a1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiopg";
    rev = "v${version}";
    hash = "sha256-9NS4oAaSODNGFcV4QHGD6PyS6wG9gsdqnSk3S24lrz0=";
  };

  propagatedBuildInputs = [
    async-timeout
    psycopg2
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "psycopg2-binary" "psycopg2"
  '';

  # Tests requires a PostgreSQL Docker instance
  doCheck = false;

  pythonImportsCheck = [ "aiopg" ];

  meta = with lib; {
    description = "Python library for accessing a PostgreSQL database";
    homepage = "https://aiopg.readthedocs.io/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
