{ stdenv, pythonOlder, buildPythonPackage, fetchPypi, six, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "hcs_utils";
  version = "2.0";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04xq69hrys8lf9kp8pva0c4aphjjfw412km7c32ydkwq0i59rhp2";
  };

  LC_ALL="en_US.UTF-8";

  checkPhase = ''
    # root does not has /root as home in sandbox
    py.test -k 'not test_expand' hcs_utils/test
  '';

  buildInputs = [ six glibcLocales ];
  checkInputs = [ pytest ];

  disabled = pythonOlder "3.4";

  meta = with stdenv.lib; {
    description = "Library collecting some useful snippets";
    homepage    = https://pypi.python.org/pypi/hcs_utils/1.3;
    license     = licenses.isc;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
