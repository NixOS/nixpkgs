{ stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, python
}:

buildPythonPackage rec {
  name = "murmurhash-${version}";
  version = "0.26.4";
  
  src = fetchFromGitHub {
    owner = "explosion";
    repo = "murmurhash";
    rev = "0.26.4";
    sha256 = "0n2j0glhlv2yh3fjgbg4d79j1c1fpchgjd4vnpw908l9mzchhmdv";    
  };

  buildInputs = [
   cython
  ];
  
  checkPhase = ''
    cd murmurhash/tests
    ${python.interpreter} -m unittest discover -p "*test*"
  '';
  
  meta = with stdenv.lib; {
    description = "Cython bindings for MurmurHash2";
    homepage = https://github.com/explosion/murmurhash;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
