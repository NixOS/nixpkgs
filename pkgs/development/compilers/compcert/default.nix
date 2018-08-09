{ stdenv, lib, fetchurl, fetchpatch
, coq, ocamlPackages
, tools ? stdenv.cc
}:

assert lib.versionAtLeast ocamlPackages.ocaml.version "4.02";

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "3.3";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "16xrqcwak1v1fk5ndx6jf1yvxv3adsr7p7z34gfm2mpggxnq0xwn";
  };

  buildInputs = [ coq ]
  ++ (with ocamlPackages; [ ocaml findlib menhir ]);

  enableParallelBuilding = true;

  patches = [ (fetchpatch {
    url = "https://github.com/AbsInt/CompCert/commit/679ecfeaa24c0615fa1999e9582bf2af6a9f35e7.patch";
   sha256 = "04yrn6dp57aw6lmlr4yssjlx9cxix0mlmaw7gfhwyz5bzqc2za1a";
  })];

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
