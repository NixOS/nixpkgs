{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, psycopg2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopg";
  version = "1.3.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GHKsI6JATiwUg+YlGhWPBqtYl+GyXWNiDi/hzPDl2hE=";
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
