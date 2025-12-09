{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "tensorman";
  version = "0.1.0-unstable-2024-06-24";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "tensorman";
    rev = "24fa3b2bb06a29708162ee474a733e9a227b1778";
    hash = "sha256-kI/dOw9JnhXmLqIgaljhRMc/SX35m7WQ9b6bQa6diZ0=";
  };

  cargoHash = "sha256-/Ul8+5MmTntQ0OprfG4QhUNjc3PktCandzTTWn4FD0Y=";

  meta = with lib; {
    description = "Utility for easy management of Tensorflow containers";
    homepage = "https://github.com/pop-os/tensorman";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thefenriswolf ];
    mainProgram = "tensorman";
  };
}
