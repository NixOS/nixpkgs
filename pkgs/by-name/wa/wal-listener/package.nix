{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
}:

buildGoModule rec {
  pname = "wal-listener";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "ihippik";
    repo = "wal-listener";
    rev = "v${version}";
    hash = "sha256-OqjCFIdU4wCiPGIMrlp+nGVr0XTNHTE8zB8/toZtM44=";
  };

  vendorHash = "sha256-VUuEVH3IUuvThIt/HJx8OE8oqbjnSeqDIQxP0sl0FJw=";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "PostgreSQL WAL listener";
    homepage = "https://github.com/ihippik/wal-listener";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
  };
}
