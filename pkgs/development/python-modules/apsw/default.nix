{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.29.0-r1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "1p3sgmk9qwd0a634lirva44qgpyq0a74r9d70wxb6hsa52yjj9xb";
  };

  buildInputs = [ sqlite ];

  patches = [
    # Fixes a test failure with sqlite 3.30, see https://github.com/rogerbinns/apsw/issues/275
    (fetchpatch {
      url = "https://github.com/rogerbinns/apsw/commit/13df0b57bff59542978abf7c0a440c9274e3aac3.diff";
      sha256 = "1wi1mfis2mr21389wdnvq44phg0bpm5vpwmxhvrj211vwfm0q7dv";
    })
  ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = https://github.com/rogerbinns/apsw;
    license = licenses.zlib;
  };
}
