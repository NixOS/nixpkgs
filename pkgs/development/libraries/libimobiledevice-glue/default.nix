{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libimobiledevice-glue";
  version = "1.3.0-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice-glue";
    rev = "362f7848ac89b74d9dd113b38b51ecb601f76094";
    hash = "";
  };

  outputs = [
    "out"
    "dev"
  ];
  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})
