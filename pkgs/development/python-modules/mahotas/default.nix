{ buildPythonPackage, fetchFromGitHub, nose, pillow, scipy, numpy, imread, stdenv }:

buildPythonPackage rec {
  pname = "mahotas";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    sha256 = "1d2hciag5sxw00qj7qz7lbna477ifzmpgl0cv3xqzjkhkn5m4d7r";
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
    homepage = http://mahotas.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
