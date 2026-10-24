{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xit";
  version = "0-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "xit-vcs";
    repo = "xit";
    rev = "1468f621d1e23e357229880ffb6c3a13cf24ee98";
    hash = "sha256-/+6+jD9ZqJHemFVi3ezvt0COU9zIq0SIbnpyy0PdRh8=";
  };

  nativeBuildInputs = [
    zig
  ];

  zigBuildFlags = [
    "--system"
    "${callPackage ./build.zig.zon.nix { }}"
  ];

  zigCheckFlags = finalAttrs.zigBuildFlags;

  # Uninitialized entries in this bitmap can misclassify deleted files.
  postPatch = ''
    substituteInPlace src/workdir.zig \
      --replace-fail 'var index_bools = try allocator.alloc(bool, index.entries.count());' \
      'var index_bools = try allocator.alloc(bool, index.entries.count());
            @memset(index_bools, false);'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 zig-out/bin/xit $out/bin/xit
    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Git-compatible version control system written in Zig";
    longDescription = ''
      xit is an experimental version control system written in Zig. It aims to
      be compatible with Git remotes and workflows while combining
      snapshot-based storage with patch-based merging. Bundled TUI.
    '';
    homepage = "https://github.com/xit-vcs/xit";
    changelog = "https://github.com/xit-vcs/xit/commit/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "xit";
    platforms = lib.platforms.unix;
  };
})
