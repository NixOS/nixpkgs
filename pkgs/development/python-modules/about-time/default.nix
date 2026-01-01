{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "about-time";
  version = "4.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rsalmei";
    repo = "about-time";
    tag = "v${version}";
    hash = "sha256-a7jFVrxUvdR5UdeNNXSTsXC/Q76unedMLmcu0iTS3Tk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=75.3" setuptools
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "about_time" ];

<<<<<<< HEAD
  meta = {
    description = "Cool helper for tracking time and throughput of code blocks, with beautiful human friendly renditions";
    homepage = "https://github.com/rsalmei/about-time";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
=======
  meta = with lib; {
    description = "Cool helper for tracking time and throughput of code blocks, with beautiful human friendly renditions";
    homepage = "https://github.com/rsalmei/about-time";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
