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

stdenv.mkDerivation (finalAttrs: {
  pname = "wsysmon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "slyfabi";
    repo = "wsysmon";
    tag = finalAttrs.version;
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

  meta = {
    description = "Windows task manager clone for Linux";
    homepage = "https://github.com/SlyFabi/WSysMon";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ totoroot ];
    mainProgram = "WSysMon";
  };
})
