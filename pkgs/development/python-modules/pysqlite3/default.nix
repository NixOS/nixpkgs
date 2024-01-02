{ lib
, buildPythonPackage
, pythonImportsCheckHook
, fetchFromGitHub
, fetchurl
, python
, sqlite
, tcl
, unittestCheckHook
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

  sqlitesrc = fetchurl {
    url = "https://www.sqlite.org/src/tarball/sqlite.tar.gz";
    hash = "sha256-jOGugJV9cD88/D3GH+uRJPm5V7LFbZIiubyOV/e4auo=";
  };

  preConfigure = ''
    tar xzf $sqlitesrc
    cd sqlite/
    ./configure
    make sqlite3.c
    cp sqlite3.[ch] ../
    cd ../
  '';

  nativeBuildInputs = [ tcl pythonImportsCheckHook unittestCheckHook ];
  buildInputs = [
    sqlite
  ];

  setupPyBuildFlags = [
    "build_static"
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
