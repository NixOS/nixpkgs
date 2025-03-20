{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
  gtk3,
  spdlog,
}:

stdenv.mkDerivation rec {
  pname = "wsysmon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "slyfabi";
    repo = "wsysmon";
    rev = version;
    hash = "sha256-5kfZT+hm064qXoAzi0RdmUqXi8VaXamlbm+FJOrGh3A=";
  };

  patches = [
    # - Dynamically link spdlog
    # - Remove dependency on procps (had a newer version than this package expected)
    #   - See https://github.com/SlyFabi/WSysMon/issues/4 for the issue about procps and why it could be removed
    # - Add an installPhase
    ./fix-deps-and-add-install.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtkmm3
    gtk3
    spdlog
  ];

  meta = with lib; {
    description = "Windows task manager clone for Linux";
    homepage = "https://github.com/SlyFabi/WSysMon";
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ totoroot ];
    mainProgram = "WSysMon";
  };
}
