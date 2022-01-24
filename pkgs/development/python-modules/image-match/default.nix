{ lib, buildPythonPackage, fetchFromGitHub, pytest-runner, scikitimage }:

buildPythonPackage {
  pname = "image-match";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ascribe";
    repo = "image-match";
    rev = "1c5f3170555540bdf43ff8b8189c4e8c13a8b950";
    sha256 = "0vlmpidmhkpgdzw2k03x5layhijcrjpmyfd93yv2ls77ihz00ix5";
  };

  buildInputs = [ pytest-runner ];

  propagatedBuildInputs = [
    scikitimage
  ];

  # remove elasticsearch requirement due to version incompatibility
  postPatch = ''
    substituteInPlace setup.py --replace "'elasticsearch>=5.0.0,<6.0.0'," ""
  '';

  # tests cannot work without elasticsearch
  doCheck = false;
  pythonImportsCheck = [ "image_match" ];

  meta = with lib; {
    homepage = "https://github.com/ascribe/image-match";
    description = "Quickly search over billions of images";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
