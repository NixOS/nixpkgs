{ stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, python
}:

buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    rev = "v${version}";
    sha256 = "0cqz6whq4zginxjnh4cfqlsh535p4qz295ymvjchp71fv8mz11f6";
  };

  propagatedBuildInputs = [
   cython
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "wheel>=0.32.0,<0.33.0" "wheel>=0.31.0"
  '';

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
