{ stdenv, buildPythonPackage, fetchPypi
, pep8, nose, unittest2, docutils, blockdiag  }:

buildPythonPackage rec {
  pname = "actdiag";
  version = "0.5.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vr4hnkr0gcvvpaycd8q3vcx029b2f5yv8swhdr8kwspaqb0dvfa";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  # One test fails:
  #   UnicodeEncodeError: 'ascii' codec can't encode character u'\u3042' in position 0: ordinal not in range(128)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
