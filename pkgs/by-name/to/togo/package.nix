{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "togo";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "prime-run";
    repo = "togo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vrRqPkgoz5CRgNOz34z9WtDMnZiltojrv9y2i5iKTHw=";
  };

  vendorHash = "sha256-7IPI02EXnEiy2OsysxL0xKZl/YASAo6xBXvUeNjYyfU=";

  ldflags = with finalAttrs; [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and simple CLI/TUI task and todo manager";
    longDescription = ''
      togo is a command line task/todo management utility designed to
      be simple, fast, and easy to use.
    '';
    homepage = "https://github.com/prime-run/togo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "togo";
  };
})
