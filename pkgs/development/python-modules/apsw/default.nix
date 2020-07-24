{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.32.2-r1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "0gwhcvklrgng8gg6in42h0aj2bsq522bhhs2pp3cqdrmypkjdm59";
  };

  buildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
  };
}
