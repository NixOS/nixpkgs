{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x18l8jgbki9yqx994w97dagfaqrbxi3sy2l2101is1dfjr0kib6";
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
