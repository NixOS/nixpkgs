{ stdenv, fetchFromGitHub, coreutils }:

stdenv.mkDerivation rec {
  name    = "owl-lisp-${version}";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner  = "aoh";
    repo   = "owl-lisp";
    rev    = "v${version}";
    sha256 = "1rr0icprna3zs834q1pj4xy21cql3pcfknfkqipq01rhnl2893sz";
  };

  prePatch = ''
    substituteInPlace Makefile --replace /usr $out

    for f in tests/run tests/exec.sh ; do
      substituteInPlace $f --replace /bin/echo ${coreutils}/bin/echo
    done
  '';

  # tests are already run as part of the compilation process
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A functional lisp";
    homepage    = https://github.com/aoh/owl-lisp;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
