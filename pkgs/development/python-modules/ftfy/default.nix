{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, wcwidth
, nose
}:

buildPythonPackage rec {
  pname = "ftfy";

  version = "5.3.0";
  # ftfy v5 only supports python3. Since at the moment the only
  # packages that use ftfy are spacy and textacy which both support
  # python 2 and 3, they have pinned ftfy to the v4 branch.
  # I propose to stick to v4 until another package requires v5.
  # At that point we can make a ftfy_v4 package.

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zybd0ypxhb83bgdbwzi120n02328v4j0ndm6bgkb6wg2gah59qb";
  };

  propagatedBuildInputs = [ html5lib wcwidth ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests -v tests
  '';

  # Several tests fail with
  # FileNotFoundError: [Errno 2] No such file or directory: 'ftfy'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken.";
    homepage = https://github.com/LuminosoInsight/python-ftfy/tree/master/tests;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll aborsu ];
  };
}
