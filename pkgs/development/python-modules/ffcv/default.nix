{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  libjpeg,
  numba,
  opencv4,
  pandas,
  pkg-config,
  pytorch-pfn-extras,
  terminaltables,
  tqdm,
}:

buildPythonPackage rec {
  pname = "ffcv";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "libffcv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-L2mwGFivq/gtAw+1D6U2jbW6VxYgetHX7OUrjwyybqE=";
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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjpeg ];
  propagatedBuildInputs = [
    opencv4
    numba
    pandas
    pytorch-pfn-extras
    terminaltables
    tqdm
  ];

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
