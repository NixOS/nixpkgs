{ buildPythonPackage, fetchFromGitHub, nose, pillow, scipy, numpy, imread, stdenv }:

buildPythonPackage rec {
  pname = "mahotas";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    sha256 = "0fjiyl82wj1a6xzr9mss2y2rydl4zchl2cbdbg0jm0fcrs99q4hw";
  };

  # remove this as soon as https://github.com/luispedro/mahotas/issues/97 is fixed
  patches = [ ./disable-impure-tests.patch ];

  propagatedBuildInputs = [ numpy imread pillow scipy ];
  checkInputs = [ nose ];

  checkPhase= ''
    python setup.py test
  '';

  disabled = stdenv.isi686; # Failing tests

  meta = with stdenv.lib; {
    description = "Computer vision package based on numpy";
    homepage = "https://mahotas.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
