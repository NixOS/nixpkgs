{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "image-go-nord";
  version = "1.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Schrodinger-Hat";
    repo = "ImageGoNord-pip";
    rev = "refs/tags/v${version}";
    hash = "sha256-2Dnl0dcdMo4PnhHTb/5cJ7C0CvW84av4CCbrTLPqopg=";
  };

  propagatedBuildInputs = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tool that can convert rgb images to nordtheme palette";
    homepage = "https://github.com/Schrodinger-Hat/ImageGoNord-pip";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
