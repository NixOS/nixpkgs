{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "rapidfuzz-cpp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g30ckm78ixsd06s067saaqbw97mkxyhfn75dr0ql7i3j9ghz7mw";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = with lib; {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/maxbachmann/rapidfuzz-cpp";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
