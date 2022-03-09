{ buildPythonPackage
, fetchFromGitHub
, lib
, libjpeg
, numba
, opencv4
, pandas
, pkgconfig
, pytorch-pfn-extras
, terminaltables
, tqdm
}:

buildPythonPackage rec {
  pname = "ffcv";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "libffcv";
    repo = pname;
    # See https://github.com/libffcv/ffcv/issues/158.
    rev = "131d56235eca3f1497bb84eeaec82c3434ef25d8";
    sha256 = "0f7q2x48lknnf98mqaa35my05qwvdgv0h8l9lpagdw6yhx0a6p2x";
  };

  # See https://github.com/libffcv/ffcv/issues/159.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'assertpy'," "" \
      --replace "'fastargs'," "" \
      --replace "'imgcat'," "" \
      --replace "'matplotlib'," "" \
      --replace "'psutil'," "" \
      --replace "'sklearn'," "" \
      --replace "'webdataset'," ""
  '';

  buildInputs = [ libjpeg pkgconfig ];
  propagatedBuildInputs = [ opencv4 numba pandas pytorch-pfn-extras terminaltables tqdm ];

  # `ffcv._libffcv*.so` cannot be loaded in the nix build environment for some
  # reason. See https://github.com/NixOS/nixpkgs/pull/160441#issuecomment-1045204722.
  doCheck = false;

  pythonImportsCheck = [ "ffcv" ];

  meta = with lib; {
    description = "FFCV: Fast Forward Computer Vision";
    homepage = "https://ffcv.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
