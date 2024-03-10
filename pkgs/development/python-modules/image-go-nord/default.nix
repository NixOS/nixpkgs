{ lib, buildPythonPackage, fetchFromGitHub, pillow, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "image-go-nord";
  version = "0.1.7";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Schrodinger-Hat";
    repo = "ImageGoNord-pip";
    rev = "refs/tags/v${version}";
    hash = "sha256-vXABG3aJ6bwT37hfo909oF8qfAY3ZW18xvr1V8vSy5w=";
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
