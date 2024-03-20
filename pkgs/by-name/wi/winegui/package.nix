{
  stdenv
, fetchFromGitHub
, pkg-config
, cppcheck
, clang-tools
, graphviz
, doxygen
, ninja
, libjson
, gtk3
, cmake
, gtkmm3
, cabextract
, wine
, p7zip
, wget
, unzip
}:
stdenv.mkDerivation rec {

  pname = "WineGUI";
  version = "2.4.2";
  src = fetchFromGitHub {
    owner = "winegui";
    repo = "WineGUI";
    rev = "v${version}";
    hash  ="sha256-7ykcIWR4Nd2F5wgPc1UE9DlysvdhN9zuFLCffNZy+w8=";
  };

  nativeBuildInputs = [
    pkg-config
    ninja
    libjson
    gtk3
    cmake
    gtkmm3
    cabextract
    wine
    p7zip
    wget
    unzip
  ];

  buildInputs = [
    doxygen
    graphviz
    clang-tools
    cppcheck
  ];


}
