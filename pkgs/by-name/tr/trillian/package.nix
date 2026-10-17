{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "trillian";
  version = "1.8.0";
  vendorHash = "sha256-Xr6qRnJmsDvWD3F6quECu+icYsSUM+I87OO099xfflM=";

  src = fetchFromGitHub {
    owner = "google";
    repo = "trillian";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5pq2bvTujaxl7W+JswFYP1fbcV5Yd2uOqFRctiIpMv8=";
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
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
