<<<<<<< HEAD
{ lib
, stdenv
, boost
, cmake
, fetchFromGitHub
, eigen
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcifpp";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-wx5D0kNKetgc/8LFAgNxTAwni+lJb2rajsxh0AASpeY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # disable network access
    "-DCIFPP_DOWNLOAD_CCD=OFF"
  ];

  buildInputs = [
    boost
    eigen
    zlib
  ];
=======
{ lib, stdenv, fetchFromGitHub, boost, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "libcifpp";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KJGcopGhCWSl+ElG3BPJjBf/kvYJowOHxto6Ci1IMco=";
  };

  nativeBuildInputs = [ cmake ];

  # disable network access
  cmakeFlags = [ "-DCIFPP_DOWNLOAD_CCD=OFF" ];

  buildInputs = [ boost zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
<<<<<<< HEAD
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/${finalAttrs.src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
