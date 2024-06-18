{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gtts-token";
  version = "1.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "boudewijn26";
    repo = "gTTS-token";
    rev = "v${version}";
    sha256 = "0vr52zc0jqyfvsccl67j1baims3cdx2is1y2lpx2kav9gadkn8hp";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires internet access
  disabledTests = [ "test_real" ];

  meta = with lib; {
    description = "Calculates a token to run the Google Translate text to speech";
    homepage = "https://github.com/boudewijn26/gTTS-token";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
