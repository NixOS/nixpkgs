{ stdenv, fetchFromGitHub, coreutils, which }:

stdenv.mkDerivation rec {
  name    = "owl-lisp-${version}";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner  = "aoh";
    repo   = "owl-lisp";
    rev    = "v${version}";
    sha256 = "0pczmra2x6icyz6b6g66pp5ij83cq4wszg0ssw8qm7a5314kxkq4";
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
