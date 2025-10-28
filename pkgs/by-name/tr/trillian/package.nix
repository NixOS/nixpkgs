{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.7.2";
  vendorHash = "sha256-5SG9CVugHIkDcpjGuZb5wekYzCj5fKyC/YxzmeptkR4=";

  src = fetchFromGitHub {
    owner = "google";
    repo = "trillian";
    rev = "v${version}";
    sha256 = "sha256-DFSG67MMpGzTlvQlW9DttLqqDkS8d8wMkeOlLQuElxU=";
  };

  subPackages = [
    "cmd/trillian_log_server"
    "cmd/trillian_log_signer"
    "cmd/createtree"
    "cmd/deletetree"
    "cmd/updatetree"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/trillian";
    description = "Transparent, highly scalable and cryptographically verifiable data store";
    license = [ licenses.asl20 ];
    maintainers = [ ];
  };
}
