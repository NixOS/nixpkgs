{
  fetchFromGitHub,
  gnat,
  gprbuild,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libvss";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "VSS";
    rev = "v${version}";
    sha256 = "sha256-XD5orxMGXFBVvc9UjSLXGb0yP5tDGNubykQ1b0B9o/k=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "A high level string and text processing library.";
    homepage = "https://github.com/AdaCore/VSS";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
