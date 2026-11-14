{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  replaceVars,
}:

buildGo127Module (finalAttrs: {
  pname = "yoke";
  version = "0.22.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yokecd";
    repo = "yoke";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0wRdAK4RBFDXkuoA0Vw/DPQkn9QgP7Khqw5Cew7CSRw=";
  };

  subPackages = [
    "cmd/yoke"
    "cmd/atc-installer"
    "cmd/atc"
    "cmd/helm2go"
    "cmd/yokecd"
    "cmd/yokecd-installer"
  ];
  vendorHash = "sha256-bShlgi7ZFSjtiNdq8WWHvly/B/jnGuk+w6Z8f3PSSRw=";

  # Yoke's test suite involves spinning up a mini kubernetes cluster using `kind`
  # so we disable it.
  doCheck = false;
  patches = [
    # patch out debug.ReadBuildInfo since version information is not available with buildGoModule
    (replaceVars ./version.patch {
      version = finalAttrs.version;
    })
  ];

  meta = {
    homepage = "https://yokecd.github.io/";
    license = lib.licenses.mit;
    description = "Infrastructure-as-code package deployer for Kubernetes";
    maintainers = with lib.maintainers; [ rschulman ];
  };
})
