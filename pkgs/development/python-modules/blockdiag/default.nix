{ stdenv, fetchurl, buildPythonPackage, pep8, nose, unittest2, docutils
, pillow, webcolors, funcparserlib
}:

buildPythonPackage rec {
  name = "blockdiag-${version}";
  version = "1.5.3";

  src = fetchurl {
    url = "https://bitbucket.org/blockdiag/blockdiag/get/${version}.tar.bz2";
    sha256 = "0r0qbmv0ijnqidsgm2rqs162y9aixmnkmzgnzgk52hiy7ydm4k8f";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ pillow webcolors funcparserlib ];

  # One test fails:
  #   ...
  #   FAIL: test_auto_font_detection (blockdiag.tests.test_boot_params.TestBootParams)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
