{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, html5lib
, wcwidth
, setuptools
, pytest
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
    html5lib
    wcwidth
    setuptools
  ];

  checkInputs = [
    pytest
  ];

  # We suffix PATH like this because the tests want the ftfy executable
  checkPhase = ''
    PATH=$out/bin:$PATH pytest
  '';

  meta = with lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.mit;
    maintainers = with maintainers; [ sdll aborsu ];
  };
}
