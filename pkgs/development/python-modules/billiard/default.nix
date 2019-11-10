{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest_4, case, psutil }:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.6.1.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8809c74f648dfe69b973c8e660bcec00603758c9db8ba89d7719f88d5f01f26";
  };

  checkInputs = [ pytest_4 case psutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/billiard;
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
