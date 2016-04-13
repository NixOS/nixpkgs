{ stdenv, fetchurl, coq, ocamlPackages
, tools ? stdenv.cc
}:

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "2.6";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "05sdxgg2w7ykw6xbcq6dl2kzxdz4qzhjajiawpy6490wqiji7wm1";
  };

  buildInputs = [ coq ] ++ (with ocamlPackages; [ ocaml findlib menhir ]);

  enableParallelBuilding = true;

  configurePhase = ''
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
