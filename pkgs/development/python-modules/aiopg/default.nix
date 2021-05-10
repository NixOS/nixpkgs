{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, psycopg2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopg";
  version = "1.2.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c6s2p1fjbdk1ygpl6a1s1rbnsk8gw9kj99pf98nxhb9j3iahas4";
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
