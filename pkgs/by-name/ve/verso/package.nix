{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  python3,
  dbus,
  mako,
  m4,
  libunwind,
  writableTmpDirAsHomeHook,
  fontconfig,
  llvmPackages,
  openssl,
  xorg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verso";
  version = "0-unstable-2025-06-15";

  src = fetchFromGitLab {
    owner = "verso-browser";
    repo = "verso";
    rev = "ace264e0e73da37bfb14818d92f0e54946ce9871";
    hash = "sha256-gjg7qs2ik1cJcE6OTGN4KdljqJDGokCo4JdR+KopMJw=";
  };

  cargoHash = "sha256-TAKn7KaW89pyfKwt+REZ2I6pJKWBl6P9x2/yhpB5prk=";

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  nativeBuildInputs = [
    llvmPackages.bintools-unwrapped
    m4
    pkg-config
    (python3.withPackages (ps: with ps; [ webidl ]))
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    fontconfig
    libunwind
    openssl
    xorg.libX11
  ];

})
