{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "zarchive";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Exzap";
    repo = "ZArchive";
    rev = "v${version}";
    hash = "sha256-hX637O/mVLTzmG0a9swJu9w+3o26VHo+K/9RhMuf1lI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zstd ];

<<<<<<< HEAD
  meta = {
    description = "File archive format supporting random-access reads";
    homepage = "https://github.com/Exzap/ZArchive";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ zhaofengli ];
=======
  meta = with lib; {
    description = "File archive format supporting random-access reads";
    homepage = "https://github.com/Exzap/ZArchive";
    license = licenses.mit0;
    maintainers = with maintainers; [ zhaofengli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "zarchive";
  };
}
