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
  version = "0.14.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "zine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nROe+jkm7t76iu9nXE5//ZAGHMStGxili7yvFE48emw=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-UWTsCHXq/Fes7uPI+VK81eH0lkwcE0a9UQ1mBceaTZM=";
  };

  nativeBuildInputs = [
    zig
  ];

  zigBuildFlags = [ "-Dversion=${finalAttrs.version}" ];

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
