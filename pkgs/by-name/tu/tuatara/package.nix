{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zig_0_13,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tuatara";
  version = "1631040452-unstable-2025-04-29";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "tuatara";
    rev = "bc093e5fe1cb8dec667806f1b41c8e4e913368e8";
    hash = "sha256-GLOb2vqDlcCQ3bPXC50t1j+DJFhl8JK117t7uRLrBbk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ zig_0_13.hook ];

  preBuild = ''
    export ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-cache
    export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-global-cache
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ziggidy *nix system info fetcher";
    longDescription = ''
      tuatara is a ziggidy *nix system info fetcher. WIP. It is
      descendant of disfetch. Although sharing some common concepts
      and principles, they are different.

      The main difference of tuatara from disfetch is that tuatara
      will be highly customizable, while disfetch won't, because it
      covers minimalism and simplicity. Though, they will share some
      other principles regarding showing only needed information,
      being fast and reliable and sharing the same handmade logos with
      the principle of not-more-or-less-than 8 rows.
    '';
    homepage = "https://github.com/q60/tuatara";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tuatara";
    platforms = lib.platforms.all;
  };
})
