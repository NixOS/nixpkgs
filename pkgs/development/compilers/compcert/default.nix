{ stdenv, lib, fetchurl
, coq, ocamlPackages
, tools ? stdenv.cc
}:

assert lib.versionAtLeast ocamlPackages.ocaml.version "4.02";

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "3.2";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "11q4121s0rxva63njjwya7syfx9w0p4hzr6avh8s57vfbrcakc93";
  };

  buildInputs = [ coq ]
  ++ (with ocamlPackages; [ ocaml findlib menhir ]);

  enableParallelBuilding = true;

  postPatch = ''
    sed -i -e 's/8\.6\.1|8\.7\.0|8\.7\.1)/8.6.1|8.7.0|8.7.1|8.7.2)/' configure
  '';

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
