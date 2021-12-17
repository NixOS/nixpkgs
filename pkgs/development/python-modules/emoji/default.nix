{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g927w9l3j5mycg6pqa4vjk2lyy35sppfp8pbzb6mvca500001rk";
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
