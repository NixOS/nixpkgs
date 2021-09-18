{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b75p1ia4ip6aq1657pdwpspvhyjw6dpsrglj2qlql2gdmcm8sp8";
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
