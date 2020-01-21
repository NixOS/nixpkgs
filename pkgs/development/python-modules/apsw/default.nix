{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.30.1-r1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "1zp38gj44bmzfxxpvgd7nixkp8vs2fpl839ag8vrh9z70dax22f0";
  };

  buildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = https://github.com/rogerbinns/apsw;
    license = licenses.zlib;
  };
}
