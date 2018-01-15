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
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9f84a1437f68ad0bb964fd9da9f6b88d090113ec9e78f290f6d6d0221468e38";
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
