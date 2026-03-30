{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "trillian";
  version = "1.7.3";
  vendorHash = "sha256-PomzPYtLEDx0mjTTidfp9dlvnW4mcVIka5AekPNYU2g=";

  src = fetchFromGitHub {
    owner = "google";
    repo = "trillian";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QOR98Xpf2iwGpqzEuB58gMsbYITiksMX4JmfqiKjeVw=";
  };

  subPackages = [
    "cmd/trillian_log_server"
    "cmd/trillian_log_signer"
    "cmd/createtree"
    "cmd/deletetree"
    "cmd/updatetree"
  ];

  meta = {
    homepage = "https://github.com/google/trillian";
    description = "Transparent, highly scalable and cryptographically verifiable data store";
    license = [ lib.licenses.asl20 ];
    maintainers = [ ];
  };
})
