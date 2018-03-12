{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, wcwidth
, nose
, python
, isPy3k
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ftfy";
  # latest is 5.1.1, buy spaCy requires 4.4.3
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ba702d5138f9b35df32b55920c9466208608108f1f3d5de1a68c17e3d68cb7f";
  };

  propagatedBuildInputs = [ html5lib wcwidth];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests -v tests
  '';

  # Several tests fail with
  # FileNotFoundError: [Errno 2] No such file or directory: 'ftfy'
  doCheck = false;

  # "this version of ftfy is no longer written for Python 2"
  disabled = !isPy3k;

  meta = with stdenv.lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken.";
    homepage = https://github.com/LuminosoInsight/python-ftfy/tree/master/tests;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
