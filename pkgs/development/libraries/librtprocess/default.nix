{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "librtprocess";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "CarVac";
    repo = "librtprocess";
    rev = version;
    hash = "sha256-/1o6SWUor+ZBQ6RsK2PoDRu03jcVRG58PNYFttriH2w=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ llvmPackages.openmp ];

  meta = with lib; {
    description = "Highly optimized library for processing RAW images";
    homepage = "https://github.com/CarVac/librtprocess";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.unix;
  };
}
