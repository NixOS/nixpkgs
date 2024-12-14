{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  numpy,
}:
buildPythonPackage rec {
  pname = "kaldiio";
  version = "2.18.0";
  src = fetchFromGitHub {
    owner = "nttcslab-sp";
    repo = "kaldiio";
    tag = "v${version}";
    hash = "sha256-B7jkz7GK3emgVrAFTKV5+CS1BWKnxk608rHWRLCBX8o=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  postPatch = ''
    substituteInPlace "setup.py" \
      --replace-fail '"pytest-runner"' ""
  '';

  pythonImportsCheck = [ "kaldiio" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Pure python module for reading and writing kaldi ark files";
    homepage = "https://github.com/nttcslab-sp/kaldiio";
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
