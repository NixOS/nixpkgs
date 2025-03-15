{
  fetchFromGitHub,
  gnat,
  gprbuild,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libadasat";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "AdaSAT";
    rev = "v${version}";
    sha256 = "sha256-ahT3HP2n866wFZmsh1nKLz8tVuIYWgInE2HsHroCihk=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "BUILD_MODE=prod"
    "all-libs"
    "INSTALL_DIR=$(out)"
  ];

  meta = with lib; {
    description = "Implementation of a DPLL-based SAT solver in Ada";
    homepage = "https://github.com/AdaCore/adasat";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
