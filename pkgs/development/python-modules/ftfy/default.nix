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
  version = "4.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "152xdb56rhs1q4r0ck1n557sbphw7zq18r75a7kkd159ckdnc01w";
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
