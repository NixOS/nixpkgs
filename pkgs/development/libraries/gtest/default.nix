{ stdenv, cmake, ninja, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "gtest-${version}";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-${version}";
    sha256 = "0270msj6n7mggh4xqqjp54kswbl7mkcc8px1p5dqdpmw5ngh9fzk";
  };

  nativeBuildInputs = [ cmake ninja ];

  meta = with stdenv.lib; {
    description = "Google's framework for writing C++ tests";
    homepage = https://github.com/google/googletest;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zoomulator ivan-tkatchev ];
  };
}
