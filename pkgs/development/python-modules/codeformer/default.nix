{ addict
  # TODO: FIXME
  # , basicsr
, stdenv
, future
, gdown
, lmdb
, lpips
, numpy
, opencv-python
, pillow
, pyyaml
, requests
, scikit-image
, scipy
, fetchFromGitHub
, buildPythonPackage
, torch
, cython
, torchvision
, tqdm
, wget
, yapf
}:

let
  nestedBasicsr = buildPythonPackage
    {
      pname = "basicsr";
      version = "0.1.2";

      src = fetchFromGitHub {
        owner = "sczhou";
        repo = "CodeFormer";
        rev = "c5b4593074ba6214284d6acd5f1719b6c5d739af";
        sha256 = "sha256-JyyJe+VBeNK5rRaPJ4jYdKZqLnRfayHWkTwFNrSfseY=";
      };

      preBuild = ''
        ln -s basicsr/setup.py setup.py
      '';

      postPatch = ''
        substituteInPlace requirements.txt \
          --replace opencv-python "" \
          --replace tb-nightly ""
      '';


      nativeBuildInputs = [ cython ];

      propagatedBuildInputs = [
        pillow
        pyyaml
        addict
        future
        gdown
        lmdb
        lpips
        numpy
        opencv-python
        requests
        scikit-image
        scipy
        torch
        torchvision
        tqdm
        wget
        yapf
      ];

      doCheck = false;

      meta = {
        description =
          "Towards Robust Blind Face Restoration with Codebook Lookup Transformer (NeurIPS 2022)";
        homepage = "None";
      };
    };
in
stdenv.mkDerivation {
  pname = "codeformer";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sczhou";
    repo = "CodeFormer";
    rev = "c5b4593074ba6214284d6acd5f1719b6c5d739af";
    sha256 = "sha256-JyyJe+VBeNK5rRaPJ4jYdKZqLnRfayHWkTwFNrSfseY=";
  };

  buildPhase = ''
    mkdir -p $out/lib/python3.10/site-packages
    cp -R ./ $out/lib/python3.10/site-packages/codeformer/
    cd $out/lib/python3.10/site-packages/codeformer/
    cp -R ${nestedBasicsr}/lib/python3.10/site-packages/basicsr ./basicsr/
  '';

  dontInstall = true;

  patches = [ ./root_dir.patch ];

  propagatedBuildInputs = [
    pillow
    pyyaml
    addict
    future
    gdown
    lmdb
    lpips
    numpy
    opencv-python
    requests
    scikit-image
    scipy
    torch
    torchvision
    tqdm
    wget
    yapf
  ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description =
      "Towards Robust Blind Face Restoration with Codebook Lookup Transformer (NeurIPS 2022)";
    homepage = "None";
  };
}
