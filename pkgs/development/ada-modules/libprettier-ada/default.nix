{
  fetchFromGitHub,
  gnat,
  gnatcoll-core,
  gprbuild,
  lib,
  libvss,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libprettier-ada";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "prettier-ada";
    rev = "v${version}";
    sha256 = "sha256-E8oKHATRkED2VNTBaqJVabb7p8rBxmCqr90LZNHudko=";
  };

  buildInputs = [
    gnatcoll-core
    libvss
  ];

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "BUILD_MODE=prod"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "This library allows users to build their own Prettier documents and format it.";
    homepage = "https://github.com/AdaCore/prettier-ada";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
