{ stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, python
}:
buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    rev = "v${version}";
    sha256 = "109i67vwgql9za8mfvgbrd6rgraz4djkvpzb4gqvzl13214s6ava";
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
