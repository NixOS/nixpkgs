{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  versionCheckHook,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zig-zlint";
  version = "0.9.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    name = "zlint"; # tests expect this
    owner = "DonIsaac";
    repo = "zlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EUTShGGp1M4ZckLgQJSXzGJQqFMx2r4zwt+mkRIPzPE=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-H4fqly0jojU0cFVkGtqZinTI7p0cRoBFKTJtSNF/+Xk=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    zig
  ];

  zigBuildFlags = [
    "-Dversion=v${finalAttrs.version}"
  ];

  doCheck = true;
  zigCheckFlags = finalAttrs.zigBuildFlags;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/zlint";

  # `zig build` produces a lot more artifacts, just copy over the ones we want
  installPhase = ''
    runHook preInstall
    install -vDm755 zig-out/bin/zlint $out/bin/zlint
    runHook postInstall
  '';

  meta = {
    description = "Linter for the Zig programming language";
    homepage = "https://github.com/DonIsaac/zlint";
    changelog = "https://github.com/DonIsaac/zlint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    mainProgram = "zlint";
    inherit (zig.meta) platforms;
  };
})
