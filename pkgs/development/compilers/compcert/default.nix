{ stdenv, lib, fetchurl
, coq, ocaml, findlib, menhir
, tools ? stdenv.cc
}:

assert lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "2.7.1";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "1vhbs1fmr9x2imqyd6yfvkbz763jhjfm9wk4nizf9rn1cvxrjqa4";
  };

  buildInputs = [ coq ocaml findlib menhir ];

  enableParallelBuilding = true;

  configurePhase = ''
    substituteInPlace ./configure --replace pl2 pl3
    substituteInPlace ./configure --replace '{toolprefix}gcc' '{toolprefix}cc'
    ./configure -prefix $out -toolprefix ${tools}/bin/ '' +
    (if stdenv.isDarwin then "ia32-macosx" else "ia32-linux");

  installTargets = "documentation install";

  postInstall = ''
    mkdir -p $lib/share/doc/compcert
    mv doc/html $lib/share/doc/compcert/
    mkdir -p $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/
    mv backend cfrontend common cparser driver flocq ia32 lib \
      $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/
  '';

  outputs = [ "out" "lib" ];

  meta = with stdenv.lib; {
    description = "Formally verified C compiler";
    homepage    = "http://compcert.inria.fr";
    license     = licenses.inria;
    platforms   = platforms.linux ++
                  platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice jwiegley vbgl ];
  };
}
