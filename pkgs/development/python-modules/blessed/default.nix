{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, six
, wcwidth, pytest, mock, glibcLocales
}:

let

  fixTestSuiteFailure_1 = fetchpatch {
    url = "https://github.com/jquast/blessed/pull/108/commits/76a54d39b0f58bfc71af04ee143459eefb0e1e7b.patch";
    sha256 = "1higmv4c03ly7ywac1d7s71f3hrl531vj16nsfl9xh6zh9c47qcg";
  };

  fixTestSuiteFailure_2 = fetchpatch {
    url = "https://github.com/jquast/blessed/pull/108/commits/aa94e01aed745715e667601fb674844b257cfcc9.patch";
    sha256 = "1frygr6sc1vakdfx1hf6jj0dbwibiqz8hw9maf1b605cbslc9nay";
  };

in

buildPythonPackage rec {
  pname = "blessed";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "777b0b6b5ce51f3832e498c22bc6a093b6b5f99148c7cbf866d26e2dec51ef21";
  };

  patches = [ fixTestSuiteFailure_1 fixTestSuiteFailure_2 ];

  checkInputs = [ pytest mock glibcLocales ];

  checkPhase = ''
    LANG=en_US.utf-8 py.test blessed/tests
  '';

  propagatedBuildInputs = [ wcwidth six ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jquast/blessed";
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
