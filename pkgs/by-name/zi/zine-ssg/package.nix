{
  callPackage,
  fetchFromGitHub,
  lib,
  stdenv,
  zig_0_15,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zine-ssg";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "zine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0rTVJ9B1JwZtl9k1t7MuSdjw6mZWaspZAVuxY5Qzw+U=";
  };

  nativeBuildInputs = [
    zig
  ];

  postConfigure = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Fast, Scalable, Flexible Static Site Generator (SSG)";
    homepage = "https://zine-ssg.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.truita ];
    mainProgram = "zine";
    inherit (zig.meta) platforms;
  };
})
