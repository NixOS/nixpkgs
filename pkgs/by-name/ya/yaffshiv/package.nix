{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation {
  pname = "yaffshiv";
  version = "0-unstable-2024-08-30";

  src = fetchFromGitHub {
    owner = "devttys0";
    repo = "yaffshiv";
    rev = "f6f0ef77bf79ca46aaa77bc34eda06e7b55da8e8";
    sha256 = "sha256-C43UzkaPKheexvVcKi/Krcik+arPXggWAYMSi9RY5eo=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    install -D -m755 src/yaffshiv $out/bin/yaffshiv
  '';

  meta = {
    description = "Simple YAFFS file system parser and extractor";
    homepage = "https://github.com/devttys0/yaffshiv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sgo ];
    mainProgram = "yaffshiv";
  };
}
