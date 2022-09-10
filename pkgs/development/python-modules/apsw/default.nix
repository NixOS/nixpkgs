{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, sqlite
, isPyPy
, python
, fetchpatch
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.39.2.1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = "refs/tags/${version}";
    hash = "sha256-W1uQFya/IQUBAPAjwdCJ1K5LVc4spcYj0dN2YP2vtN0=";
  };

  buildInputs = [
    sqlite
  ];

  patches = [
    # ongoing issue: https://github.com/rogerbinns/apsw/issues/363
    # apsw needs to know the compile flags of sqlite to match features
    (fetchpatch {
      url = "https://github.com/rogerbinns/apsw/commit/e92f019ff785d8e52d381dc541d3f4f8236fb356.patch";
      hash = "sha256-Zdy0ukfWkak9lTdU5WMNzWNp7uDROJgXLcfvQdfm2Oo=";
    })
  ];

  # Project uses custom test setup to exclude some tests by default, so using pytest
  # requires more maintenance
  # https://github.com/rogerbinns/apsw/issues/335
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  pythonImportsCheck = [
    "apsw"
  ];

  meta = with lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
