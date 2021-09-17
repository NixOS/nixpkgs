{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v.${version}";
    sha256 = "072m0l1wcbz1jiyc2x5dx0b4ks5zri7m5lhjjy9sgq4qwlqsnr5n";
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
