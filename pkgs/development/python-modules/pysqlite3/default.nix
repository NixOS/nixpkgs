{ lib
, buildPythonPackage
, pythonImportsCheckHook
, fetchFromGitHub
, python
, sqlite
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysqlite3";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "pysqlite3";
    rev = version;
    hash = "sha256-Ik//afKc7v1iBRGwOZrQbbMsHmdH5FptS9EAldhKRmk=";
  };

  nativeBuildInputs = [ pythonImportsCheckHook pytestCheckHook ];
  buildInputs = [
    sqlite
  ];

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  pythonImportsCheck = [ "pysqlite3" ];

  meta = with lib; {
    homepage = "https://github.com/coleifer/pysqlite3";
    description = "SQLite3 DB-API 2.0 driver from Python 3";
    mainProgram = "pysqlite3";
    maintainers = with maintainers; [ d3vil0p3r ];
    license = licenses.zlib;
  };
}
