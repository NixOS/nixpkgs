{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools_scm
, future
, isPy3k
, python
, hypothesis
}:

buildPythonPackage rec {
  version = "0.1.1";
  pname = "backports.os";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b472c4933094306ca08ec90b2a8cbb50c34f1fb2767775169a1c1650b7b74630";
  };

  buildInputs = [ setuptools_scm ];
  checkInputs = [ hypothesis ];
  propagatedBuildInputs = [ future ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pjdelport/backports.os;
    description = "Backport of new features in Python's os module";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
