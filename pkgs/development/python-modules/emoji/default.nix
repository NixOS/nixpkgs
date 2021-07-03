{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "v.${version}";
    sha256 = "0xksxdld20sh3c2s6pry1fm2br9xq8ypdq5pf971fpg5pk2f4iy9";
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
