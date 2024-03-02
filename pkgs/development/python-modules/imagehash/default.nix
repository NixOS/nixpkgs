{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, numpy
, six
, scipy
, pillow
, pywavelets
}:

buildPythonPackage rec {
  pname = "imagehash";
  version = "4.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JohannesBuchner";
    repo = "imagehash";
    rev = "v${version}";
    hash = "sha256-Tsq10TZqnzNTuO4goKjdylN4Eqy7DNbHLjr5n3+nidM=";
  };

  propagatedBuildInputs = [
    numpy
    six
    scipy
    pillow
    pywavelets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A Python Perceptual Image Hashing Module";
    homepage = "https://github.com/JohannesBuchner/imagehash";
    license = licenses.bsd2;
    maintainers = with maintainers; [ e1mo ];
  };
}
