{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.33.0-r1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "05mxcw1382xx22285fnv92xblqby3adfrvvalaw4dc6rzsn6kcan";
  };

  buildInputs = [ sqlite ];

  meta = with lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
  };
}
