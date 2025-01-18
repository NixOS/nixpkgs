{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "treeland-protocols";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-SS4jnfr/9Ec3qpnHS4EjQViekBRMix5oz7b9qhNZpfY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Wayland protocol extensions for treeland";
    homepage = "https://github.com/linuxdeepin/treeland-protocols";
    license = with licenses; [
      gpl3Only
      lgpl3Only
      asl20
    ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
