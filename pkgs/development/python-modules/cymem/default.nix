{ stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, python
}:
buildPythonPackage rec {
  name = "cymem-${version}";
  version = "1.31.2";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    rev = "1.31.2";
    sha256 = "0miznr4kbdzw8yik3m96jmrlmln4qv7z3i3qdp7wjqr51zpqfm1k";
  };

  propagatedBuildInputs = [
   cython   
  ];
    
  checkPhase = ''
    cd cymem/tests
    ${python.interpreter} -m unittest discover -p "*test*"
  '';
  
  meta = with stdenv.lib; {
    description = "Cython memory pool for RAII-style memory management";
    homepage = https://github.com/explosion/cymem;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
