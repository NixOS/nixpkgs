{ buildPythonPackage, fetchFromGitHub, nose, pillow, scipy, numpy, imread, stdenv }:

buildPythonPackage rec {
  pname = "mahotas";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "mahotas";
    rev = "v${version}";
    sha256 = "0dm34751w1441lxq00219fqlqix5qrgc18wp1wgp7xivlz3czzcz";
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
    platforms = platforms.unix;
  };
}
