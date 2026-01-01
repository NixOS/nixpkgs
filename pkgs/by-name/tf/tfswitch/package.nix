{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tfswitch";
<<<<<<< HEAD
  version = "1.13.0";
=======
  version = "1.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-rS7VJQdRzrEK1ZlpmdbAf32vKuyK9I0tflDIC1Nb2OY=";
  };

  vendorHash = "sha256-JJnXleHt7lRnKHBh4Lx71Jb0RRCdUOqzrNHbZ17T5Co=";
=======
    sha256 = "sha256-c1ueznf3ihsZeLmhD35NZ3pvK79LaonIymu2/2KwbZM=";
  };

  vendorHash = "sha256-MF+P+t+8xVRB4AicuVSqs1VEmBBo180bz2IdHi58vWc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Disable tests since it requires network access and relies on the
  # presence of release.hashicorp.com
  doCheck = false;

  postInstall = ''
    # The binary is named tfswitch
    mv $out/bin/terraform-switcher $out/bin/tfswitch
  '';

<<<<<<< HEAD
  meta = {
    description = "Command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
=======
  meta = with lib; {
    description = "Command line tool to switch between different versions of terraform";
    mainProgram = "tfswitch";
    homepage = "https://github.com/warrensbox/terraform-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
