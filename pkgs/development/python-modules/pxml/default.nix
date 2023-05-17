{ lib
, pythonAtLeast
, buildPythonPackage
, fetchPypi
, blessings
, six
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "pxml";
  version = "0.2.13";
  disabled = pythonAtLeast "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c9zzfv6ciyf9qm7556wil45xxgykg1cj8isp1b88gimwcb2hxg4";
  };

  propagatedBuildInputs = [ blessings six ];
  nativeCheckInputs = [ nose coverage ];

  # test_prefixedWhitespace fails due to a python3 StringIO issue requiring
  # bytes rather than str
  checkPhase = ''
    nosetests -e 'test_prefixedWhitespace'
  '';

  meta = with lib; {
    homepage = "https://github.com/metagriffin/pxml";
    description = ''A python library and command-line tool to "prettify" and colorize XML.'';
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl3;
  };
}
