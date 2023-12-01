{ lib
, stdenv
, fetchFromGitHub
, pcre2
}:

stdenv.mkDerivation rec {
  pname = "jpcre2";
  version = "10.32.01";
  rev = version;

  src = fetchFromGitHub {
    owner = "jpcre2";
    repo = "jpcre2";
    rev = "refs/tags/${version}";
    hash = "sha256-CizjxAiajDLqajZKizMRAk5UEZA+jDeBSldPyIb6Ic8=";
  };

  buildInputs = [ pcre2 ];

  meta = with lib; {
    homepage = "https://docs.neuzunix.com/jpcre2/latest/";
    description = "C++ wrapper for PCRE2 Library";
    platforms = lib.platforms.all;
    license = licenses.bsd3;
  };
}
