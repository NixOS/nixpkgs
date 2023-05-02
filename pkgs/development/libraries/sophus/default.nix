{ lib
, stdenv
, fetchFromGitHub
, cmake
, eigen
, fmt
}:

stdenv.mkDerivation {
  name = "sophus";
  version = "1.22.10";
  nativeBuildInputs = [cmake];
  buildInputs = [eigen fmt];
  src = fetchFromGitHub {
    owner = "strasdat";
    repo = "Sophus";
    rev = "1.22.10";
    hash = "sha256-TNuUoL9r1s+kGE4tCOGFGTDv1sLaHJDUKa6c9x41Z7w=";
  };
  meta = with lib; {
    homepage = "https://github.com/strasdat/Sophus";
    description = "C++ implementation of Lie Groups using Eigen";
    license = licenses.mit;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
