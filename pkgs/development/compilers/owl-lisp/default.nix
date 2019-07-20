{ stdenv, fetchFromGitHub, coreutils, which }:

stdenv.mkDerivation rec {
  name    = "owl-lisp-${version}";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner  = "aoh";
    repo   = "owl-lisp";
    rev    = "v${version}";
    sha256 = "1qp6p48bmlyn83rqi6k3d098dg4cribavg5rd4x17z37i181vxvj";
  };

  nativeBuildInputs = [ which ];

  prePatch = ''
    substituteInPlace Makefile --replace /usr $out

    for f in tests/run tests/exec.sh ; do
      substituteInPlace $f --replace /bin/echo ${coreutils}/bin/echo
    done
  '';

  # tests are run as part of the compilation process
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A functional lisp";
    homepage    = https://github.com/aoh/owl-lisp;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
