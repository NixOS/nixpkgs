{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "timescaledb-tune";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-tune";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fQx+c6kdA8we1hrlIhiQjxOGKSbHqjWzNWLxX7xT3dU=";
  };

  vendorHash = "sha256-S48WxFXxuKz7gp+a7I8l2UKBxQ1AAs9VAxv6l0YnRhg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for tuning your TimescaleDB for better performance";
    mainProgram = "timescaledb-tune";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
