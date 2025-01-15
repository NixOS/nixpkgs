{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "yopass-ng";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "yopass-ng";
    rev = "v${version}";
    hash = "sha256-RPGd16ojfhipRZtlZpxdBIkh1uF0Xe62TPP87fGIkc4=";
  };

  vendorHash = "sha256-bvbgIbNTxwYZN8t49ygk8sBq5e8KM9rLY8YOhbhN+4g=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/yopass-ng/releases/tag/v${version}";
    homepage = "https://paepcke.de/yopass-ng";
    description = "Yopass, selfhosted secret sharing service, as convenient, all-in-one embedded, multilingual, hardened single binary.";
    license = lib.licenses.bsd3;
    mainProgram = "yopass-ng";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
