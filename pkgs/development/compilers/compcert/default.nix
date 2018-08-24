{ stdenv, lib, fetchFromGitHub, fetchpatch
, coq, coq2html, ocamlPackages
, tools ? stdenv.cc
}:

assert lib.versionAtLeast ocamlPackages.ocaml.version "4.02";

stdenv.mkDerivation rec {
  name    = "compcert-2018-08-24";

  src = fetchFromGitHub {
    owner = "AbsInt";
    repo = "CompCert";
    rev = "78ce76b87a7de88dcdf6d742428d5474dac19867";
    sha256 = "1g9s3z1z6aiacd7z3dc23fr8d163znz418rrl2k6za63b46k68b2";
  };

  buildInputs = [ coq coq2html ]
  ++ (with ocamlPackages; [ ocaml findlib menhir ]);

  enableParallelBuilding = true;

  configurePhase = ''
    substituteInPlace ./configure --replace '{toolprefix}gcc' '{toolprefix}cc'
    ./configure -clightgen -prefix $out -toolprefix ${tools}/bin/ '' +
    (if stdenv.isDarwin then "x86_64-macosx" else "x86_64-linux");

  installTargets = "documentation install";

  postInstall = ''
    mkdir -p $lib/share/doc/compcert
    mv doc/html $lib/share/doc/compcert/
    mkdir -p $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/
    mv backend cfrontend common cparser driver flocq x86 x86_64 lib \
      $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/
  '';

  outputs = [ "out" "lib" ];

  meta = with stdenv.lib; {
    description = "Formally verified C compiler";
    homepage    = "http://compcert.inria.fr";
    license     = licenses.inria-compcert;
    platforms   = platforms.linux ++
                  platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice jwiegley vbgl ];
  };
}
