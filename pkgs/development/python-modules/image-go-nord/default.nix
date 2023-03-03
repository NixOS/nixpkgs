{ lib, buildPythonPackage, fetchFromGitHub, pillow, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "image-go-nord";
  version = "0.1.5";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Schrodinger-Hat";
    repo = "ImageGoNord-pip";
    rev = "v${version}";
    sha256 = "sha256-O34COlGsXExJShRd2zvhdescNfYXWLNuGpkjcH3koPU=";
  };

  propagatedBuildInputs = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A tool that can convert rgb images to nordtheme palette";
    homepage = "https://github.com/Schrodinger-Hat/ImageGoNord-pip";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
