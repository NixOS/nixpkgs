{ stdenv
, buildPythonPackage
, fetchPypi
#, glibcLocales
, python
, pdftk
, isPy3k
}:

buildPythonPackage rec {
  pname = "pypdftk";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kl1kyqi5d8lwzlbv8430qvzz4q2jg8nv5sakd1i1qmnkn61g5n5";
  };

  #LC_ALL = "en_US.UTF-8";
  #buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  # Tests broken on Python 3.x
  doCheck = !(isPy3k);

  meta = with stdenv.lib; {
    description = "Python wrapper for PDFTK";
    homepage = "https://github.com/revolunet/pypdftk";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cap ];
  };

}
