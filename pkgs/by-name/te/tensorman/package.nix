{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "tensorman";
  version = "unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "tensorman";
    rev = "b1125f71b55a8d9a4d674a62fa1e8868d40d0f0d";
    hash = "sha256-WMX+nzNQTGeSUxOfMHo+U0ICYx8rttXpQrQClwU2zX8=";
  };

  cargoHash = "sha256-y/AE2jTVetqBBExBlPEB0LwIVk+LjB2i0ZjijLPs9js=";

  meta = with lib; {
    description = "Utility for easy management of Tensorflow containers";
    homepage = "https://github.com/pop-os/tensorman";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thefenriswolf ];
    mainProgram = "tensorman";
  };
}
