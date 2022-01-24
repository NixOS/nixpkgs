{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, wcwidth
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.0.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba71121a9c8d7790d3e833c6c1021143f3e5c4118293ec3afb5d43ed9ca8e72b";
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
