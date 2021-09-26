{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v${version}";
    sha256 = "11v8zqz183vpiyg2cp0fghb1hxqsn3yaydm1d97nqd9g2mfy37s1";
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
