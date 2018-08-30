{ stdenv, buildPythonPackage, fetchFromGitHub
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.22.0-r1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "02ldvshcgr4c7c8anp4flfnw8g8ys5bflkb8b51rb618qxhhwyak";
  };

  buildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = https://github.com/rogerbinns/apsw;
    license = licenses.zlib;
  };
}
