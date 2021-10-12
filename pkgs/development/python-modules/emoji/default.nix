{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sxqw1y070cpg7102a6a1bha8s25vwdgfcjp9nzlrzgd2p6pav41";
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
