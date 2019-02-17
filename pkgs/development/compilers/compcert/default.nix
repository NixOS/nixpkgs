{ stdenv, lib, fetchurl, fetchpatch, makeWrapper
, coq, ocamlPackages, coq2html
, tools ? stdenv.cc
}:

assert lib.versionAtLeast ocamlPackages.ocaml.version "4.02";
assert lib.versionAtLeast coq.coq-version "8.6.1";

let
  ocaml-pkgs      = with ocamlPackages; [ ocaml findlib menhir ];
  ccomp-platform = if stdenv.isDarwin then "x86_64-macosx" else "x86_64-linux";
in
stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "3.4";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "12gchwvkzhd2bhrnwzfb4a06wc4hgv98z987k06vj7ga31ii763h";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = ocaml-pkgs ++ [ coq coq2html ];
  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace ./configure \
      --replace '{toolprefix}gcc' '{toolprefix}cc'
  '';

  configurePhase = ''
    ./configure -clightgen \
      -prefix $out \
      -toolprefix ${tools}/bin/ \
      ${ccomp-platform}
  '';

  installTargets = "documentation install";
  postInstall = ''
    # move man into place
    mkdir -p $man/share
    mv $out/share/man/ $man/share/

    # move docs into place
    mkdir -p $doc/share/doc/compcert
    mv doc/html $doc/share/doc/compcert/

    # install compcert lib files; remove copy from $out, too
    mkdir -p $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/
    mv backend cfrontend common cparser driver flocq x86 x86_64 lib \
      $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/
    rm -rf $out/lib/compcert/coq

    # wrap ccomp to undefine _FORTIFY_SOURCE; ccomp invokes cc1 which sets
    # _FORTIFY_SOURCE=2 by default, but undefines __GNUC__ (as it should),
    # which causes a warning in libc. this suppresses it.
    for x in ccomp clightgen; do
      wrapProgram $out/bin/$x --add-flags "-U_FORTIFY_SOURCE"
    done
  '';

  outputs = [ "out" "lib" "doc" "man" ];

  meta = with stdenv.lib; {
    description = "Formally verified C compiler";
    homepage    = "http://compcert.inria.fr";
    license     = licenses.inria-compcert;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ thoughtpolice jwiegley vbgl ];
  };
}
