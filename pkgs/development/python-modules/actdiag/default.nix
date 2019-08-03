{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pep8, nose, unittest2, docutils, blockdiag, reportlab }:

buildPythonPackage rec {
  pname = "actdiag";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "983071777d9941093aaef3be1f67c198a8ac8d2bba264cdd1f337ca415ab46af";
  };

  patches = fetchpatch {
    name = "drop_test_pep8.py.patch";
    url = https://bitbucket.org/blockdiag/actdiag/commits/c1f2ed5947a1e93291f5860e4e30cee098bd635d/raw;
    sha256 = "1zxzwb0fvwlc8xgs45fx65341sjhb3h6l2p6rdj6i127vg1hsxb4";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  checkInputs = [ reportlab ];

  meta = with stdenv.lib; {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
