{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "cfv";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "cfv-project";
    repo = "cfv";
    rev = "refs/tags/v${version}";
    sha256 = "1wxf30gsijsdvhv5scgkq0bqi8qi4dgs9dwppdrca5wxgy7a8sn5";
  };

  meta = {
    description = "Utility to verify and create a wide range of checksums";
    homepage = "https://github.com/cfv-project/cfv";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jjtt ];
  };
}
