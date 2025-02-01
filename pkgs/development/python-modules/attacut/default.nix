{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  setuptools,

  pytestCheckHook,

  docopt,
  fire,
  numpy,
  python-crfsuite,
  pyyaml,
  six,
  ssg,
  torch,
}:

buildPythonPackage rec {
  pname = "attacut";
  version = "1.1.0-dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyThaiNLP";
    repo = "attacut";
    rev = "refs/tags/v${version}";
    hash = "sha256-x3JJC1Xd+tsOAHJEHGzIrhIrNGSvLSanAFc7+uXb2Kk=";
  };

  # no more need, see patch...
  postPatch = ''
    sed -i "/nptyping>=/d" setup.py
  '';

  patches = [
    (fetchpatch {
      name = "fix-nptyping-deprecated-array.patch";
      url = "https://github.com/PyThaiNLP/attacut/commit/a707297b3f08a015d32d8ac241aa8cb11128cbd4.patch";
      includes = [ "attacut/evaluation.py" ];
      hash = "sha256-k2DJPwiH1Fyf5u6+zavx0bankCXsJVZrw1MGcf8ZL+M=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    docopt
    fire
    numpy
    python-crfsuite
    pyyaml
    six
    ssg
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/*" ];

  pythonImportsCheck = [ "attacut" ];

  meta = with lib; {
    description = "A Fast and Accurate Neural Thai Word Segmenter";
    homepage = "https://github.com/PyThaiNLP/attacut";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
    mainProgram = "attacut-cli";
  };
}
