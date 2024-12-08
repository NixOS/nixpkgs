{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  xen,
}:
rustPlatform.buildRustPackage rec {
  pname = "xen-guest-agent";
  version = "0.4.0-unstable-2024-05-31";

  src = fetchFromGitLab {
    owner = "xen-project";
    repo = pname;
    rev = "03aaadbe030f303b1503e172ee2abb6d0cab7ac6";
    hash = "sha256-OhzRsRwDvt0Ov+nLxQSP87G3RDYSLREMz2w9pPtSUYg=";
  };

  cargoHash = "sha256-E6QKh4FFr6sLAByU5n6sLppFwPHSKtKffhQ7FfdXAu4=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [ xen ];

  postInstall =
    # Install the sample systemd service.
    ''
      mkdir --parents $out/lib/systemd/system
      cp $src/startup/xen-guest-agent.service $out/lib/systemd/system
      substituteInPlace $out/lib/systemd/system/xen-guest-agent.service \
        --replace-fail "/usr/sbin/xen-guest-agent" "$out/bin/xen-guest-agent"
    '';

  postFixup =
    # Add the Xen libraries in the runpath so the guest agent can find libxenstore.
    "patchelf $out/bin/xen-guest-agent --add-rpath ${xen}/lib";

  meta = {
    description = "Xen agent running in Linux/BSDs (POSIX) VMs";
    homepage = "https://gitlab.com/xen-project/xen-guest-agent";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = lib.teams.xen.members;
    mainProgram = "xen-guest-agent";
  };
}
