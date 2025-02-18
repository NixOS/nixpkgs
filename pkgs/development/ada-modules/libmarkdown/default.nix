{
  fetchFromGitHub,
  gnat,
  gprbuild,
  lib,
  libvss,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libmarkdown";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "markdown";
    rev = "v${version}";
    sha256 = "sha256-kmm1TzlaOEWOZjW4ShBr/rqCQOxPVTKUfApf6oIu+K0=";
  };

  buildInputs = [
    libvss
  ];

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "This library provides a markdown parser written in Ada.";
    homepage = "https://github.com/AdaCore/markdown";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
