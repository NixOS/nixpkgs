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

  sqlitesrc = sqlite.src;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace /usr $out
  '';

  preConfigure = ''
    cp $sqlitesrc /build/source/sqlite.tar.gz
    tar xzf sqlite.tar.gz
    cd sqlite-autoconf-3430200
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
    "build_ext"
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
