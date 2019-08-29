{ stdenv, fetchFromGitHub, coq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-coq-extensible-records-1.2.0";

  src = fetchFromGitHub {
    owner = "gmalecha";
    repo = "coq-extensible-records";
    rev = "1.2.0";
    sha256 = "0h5m04flqfk0v577syw0v1dw2wf7xrx6jaxv5gpmqzssf5hxafy4";
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gmalecha/coq-extensible-records;
    description = "Implementation of extensible records in Coq";
    license = licenses.mit;
    maintainers = with maintainers; [ ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" ];
  };
}
