{ buildPythonPackage
, fetchFromGitHub
, lib
, numpy
, pillow
, pytestCheckHook
, pywavelets
, scipy
, six
}: buildPythonPackage rec {
  pname = "imagehash";
  version = "4.3.1";
  src = fetchFromGitHub {
    owner = "JohannesBuchner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Tsq10TZqnzNTuO4goKjdylN4Eqy7DNbHLjr5n3+nidM=";
  };

  propagatedBuildInputs = [ numpy pillow pywavelets scipy six ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A Python Perceptual Image Hashing Module";
    homepage = "https://github.com/JohannesBuchner/imagehash";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ehllie ];
  };
}
