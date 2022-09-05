{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-8Wm0yqCnscUc5da4c2hLOQsFMcr3XVe8FArX9wllo8Q=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_emojize_name_only"
  ];

  pythonImportsCheck = [ "emoji" ];

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://github.com/carpedm20/emoji/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
