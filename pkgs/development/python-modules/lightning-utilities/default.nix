{ lib
, buildPythonPackage
, fetchFromGitHub
, fire
}:

buildPythonPackage rec {
  pname = "lightning-utilities";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "utilities";
    rev = "v${version}";
    hash = "sha256-SL27X4pykHfTFub6Lu2imZ34T8syfaRfRhfFKUaeIy8=";
  };

  propagatedBuildInputs = [
    fire
  ];

  pythonImportsCheck = [ "lightning_utilities" ];

  meta = with lib; {
    description = "Common Python utilities and GitHub Actions in Lightning Ecosystem";
    homepage = "https://pytorch-lightning.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
