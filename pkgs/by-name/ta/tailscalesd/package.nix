{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tailscalesd";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cfunkhouser";
    repo = "tailscalesd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-avGgkGgzeupZwqRPT1juRyTs6udpefTI0W0rqmvhwk0=";
  };

  vendorHash = "sha256-DowF+3eTe+bC3wqfIznCaLwcl42vRyEzFCbMRZffZS8=";
=======
    hash = "sha256-OcvLVsPtAIaGTxk5SKNme0+i0PsDc8uY/sDcM/L5yqU=";
  };

  vendorHash = "sha256-cBHAo2RL7Q6TJbv1QYrescMFwbSUnGlOmTqqt8CZ/qc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Prometheus Service Discovery for Tailscale";
    changelog = "https://github.com/cfunkhouser/tailscalesd/releases/tag/v${version}";
    homepage = "https://github.com/cfunkhouser/tailscalesd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "tailscalesd";
  };
}
