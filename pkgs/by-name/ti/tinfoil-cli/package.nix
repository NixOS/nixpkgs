{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tinfoil-cli";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-cli";
    tag = "v${version}";
    hash = "sha256-0G+5TQmWv++i5LTIEvYjElywxhLPUnIGTzw7kbEwBt0=";
  };

  vendorHash = "sha256-lKS/62+ugV6L4rxDGZhwZvRoYF4L6jIVzChZo5D6dlg=";

  # The checks run tests requiring internet access
  doCheck = false;

  postInstall = ''
    mv $out/bin/tinfoil-cli $out/bin/tinfoil
  '';

  meta = {
    description = "Command-line interface for making verified HTTP requests to Tinfoil enclaves and validating attestation documents";
    homepage = "https://github.com/tinfoilsh/tinfoil-cli";
    changelog = "https://github.com/tinfoilsh/tinfoil-cli/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "tinfoil";
  };
}
