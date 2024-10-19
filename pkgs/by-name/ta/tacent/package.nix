{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "tacent";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "tacent";
    rev = version;
    hash = "sha256-z8VuJS8OaVw5CeO/udvBEmcURKIy1oWVYUv6Ai8lTI8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "C++ library providing linear algebra and various utility functions";
    longDescription = ''
      A C++ library implementing linear algebra, text and file IO, UTF-N conversions,
      containers, image loading/saving, image quantization/filtering, command-line parsing, etc.
    '';
    homepage = "https://github.com/bluescan/tacent";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ PopeRigby ];
    platforms = lib.platforms.linux;
  };

}
