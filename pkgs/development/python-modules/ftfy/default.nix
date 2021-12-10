{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, wcwidth
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.0.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
     owner = "LuminosoInsight";
     repo = "python-ftfy";
     rev = "v6.0.3";
     sha256 = "00670f9zjhiqq054cc4rh532w5m8ir9wajf4hmrn14y1a1k5v8a1";
  };

  propagatedBuildInputs = [
    wcwidth
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
