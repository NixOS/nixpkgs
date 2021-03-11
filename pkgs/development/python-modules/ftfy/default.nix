{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, wcwidth
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "5.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c4fb2863c0b82eae2ab3cf353d9ade268dfbde863d322f78d6a9fd5cefb31e9";
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
    maintainers = with maintainers; [ sdll aborsu ];
  };
}
