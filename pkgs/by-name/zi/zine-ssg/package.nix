{
  fetchFromGitHub,
  lib,
  stdenv,
  zig_0_17,
  nix-update-script,
}:

let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zine-ssg";
  version = "0.14.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "zine";
    rev = "f8d2cda6b290584cd593cdefe35486f1e9b0a076";
    hash = "sha256-Ywk4z2s0MFPkqbQNL0n1jlhnQ66TE6uiezVwTzMmxQY=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-B+fycNWXVDiWZ2yPlYBXsNQEoOX8xGBDf+WitxOwfcc=";
  };

  nativeBuildInputs = [
    zig
  ];

  zigBuildFlags = [ "-Dno-git-version" ];

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, Scalable, Flexible Static Site Generator (SSG)";
    homepage = "https://zine-ssg.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ truita ];
    mainProgram = "zine";
    inherit (zig.meta) platforms;
  };
})
