{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, html5lib
, wcwidth
, pytest
}:

buildPythonPackage rec {
  pname = "ftfy";

  version = "5.6";
  # ftfy v5 only supports python3. Since at the moment the only
  # packages that use ftfy are spacy and textacy which both support
  # python 2 and 3, they have pinned ftfy to the v4 branch.
  # I propose to stick to v4 until another package requires v5.
  # At that point we can make a ftfy_v4 package.
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k4vr5rfa62yafwpmb4827n50pwb79if0vhg1y4yqbb0bv20jxbd";
  };

  propagatedBuildInputs = [
    html5lib
    wcwidth
  ];

  checkInputs = [
    pytest
  ];

  # We suffix PATH like this because the tests want the ftfy executable
  checkPhase = ''
    PATH=$out/bin:$PATH pytest
  '';

  meta = with stdenv.lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    homepage = https://github.com/LuminosoInsight/python-ftfy;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll aborsu ];
  };
}
