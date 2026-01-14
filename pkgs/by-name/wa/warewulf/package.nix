{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gpgme,
}:

buildGoModule rec {
  pname = "warewulf";
  version = "4.5.8";

  src = fetchFromGitHub {
    owner = "warewulf";
    repo = "warewulf";
    rev = "refs/tags/v${version}";
    hash = "sha256-PjbPho4MVnXtIEKu4sIlReZ5j+K8FaDVzTnFYO6FXVQ=";
  };

  vendorHash = "sha256-nfMqCm/y3Nj+8sasoqNQcG1dKymsyBqz3Swe0l+gS18=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gpgme ];

  preBuild = ''
    make config
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.revision=${src.rev}"
  ];

  # Tests require containers running
  doCheck = false;

  meta = {
    description = "Stateless and diskless container operating system provisioning system";
    changelog = "https://github.com/warewulf/warewulf/blob/v${version}/CHANGELOG.md";
    homepage = "https://warewulf.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.unix;
  };
}
