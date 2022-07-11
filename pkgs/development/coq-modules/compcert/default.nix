{ lib, fetchzip, mkCoqDerivation
, coq, flocq, compcert
, ocamlPackages, fetchpatch, makeWrapper, coq2html
, stdenv, tools ? stdenv.cc
, version ? null
}:

with lib;

let compcert = mkCoqDerivation rec {

  pname = "compcert";
  owner = "AbsInt";

  inherit version;
  releaseRev = v: "v${v}";

  defaultVersion =  with versions; switch coq.version [
      { case = range "8.14" "8.15"; out = "3.11"; }
      { case = isEq "8.13"        ; out = "3.10"; }
      { case = isEq "8.12"       ; out = "3.9"; }
      { case = range "8.8" "8.11"; out = "3.8"; }
    ] null;

  release = {
    "3.8".sha256 = "1gzlyxvw64ca12qql3wnq3bidcx9ygsklv9grjma3ib4hvg7vnr7";
    "3.9".sha256 = "1srcz2dqrvmbvv5cl66r34zqkm0hsbryk7gd3i9xx4slahc9zvdb";
    "3.10".sha256 = "sha256:19rmx8r8v46101ij5myfrz60arqjy7q3ra3fb8mxqqi3c8c4l4j6";
    "3.11".sha256 = "sha256-ZISs/ZAJVWtxp9+Sg5qV5Rss1gI9hK769GnBfawLa6A=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with ocamlPackages; [ ocaml findlib menhir menhirLib ] ++ [ coq coq2html ];
  propagatedBuildInputs = [ flocq ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace ./configure \
      --replace \$\{toolprefix\}ar 'ar' \
      --replace '{toolprefix}gcc' '{toolprefix}cc'
  '';

  configurePhase = ''
    ./configure -clightgen \
    -prefix $out \
    -coqdevdir $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/ \
    -toolprefix ${tools}/bin/ \
    -use-external-Flocq \
    ${if stdenv.isDarwin then "x86_64-macosx" else "x86_64-linux"}
  '';

  installTargets = "documentation install";
  installFlags = []; # trust ./configure
  preInstall = ''
    mkdir -p $out/share/man
    mkdir -p $man/share
  '';
  postInstall = ''
    # move man into place
    mv $out/share/man/ $man/share/

    # move docs into place
    mkdir -p $doc/share/doc/compcert
    mv doc/html $doc/share/doc/compcert/

    # wrap ccomp to undefine _FORTIFY_SOURCE; ccomp invokes cc1 which sets
    # _FORTIFY_SOURCE=2 by default, but undefines __GNUC__ (as it should),
    # which causes a warning in libc. this suppresses it.
    for x in ccomp clightgen; do
      wrapProgram $out/bin/$x --add-flags "-U_FORTIFY_SOURCE"
    done
  '';

  outputs = [ "out" "lib" "doc" "man" ];

  meta = with lib; {
    description = "Formally verified C compiler";
    homepage    = "https://compcert.org";
    license     = licenses.inria-compcert;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ thoughtpolice jwiegley vbgl ];
  };
}; in
compcert.overrideAttrs (o:
  {
    patches = with versions; switch [ coq.version o.version ] [
      { cases = [ (range "8.12.2" "8.13.2") "3.8" ];
        out = [
          # Support for Coq 8.12.2
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/06956421b4307054af221c118c5f59593c0e67b9.patch";
            sha256 = "1f90q6j3xfvnf3z830bkd4d8526issvmdlrjlc95bfsqs78i1yrl";
          })
          # Support for Coq 8.13.0
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/0895388e7ebf9c9f3176d225107e21968919fb97.patch";
            sha256 = "0qhkzgb2xl5kxys81pldp3mr39gd30lvr2l2wmplij319vp3xavd";
          })
          # Support for Coq 8.13.1
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/6bf310dd678285dc193798e89fc2c441d8430892.patch";
            sha256 = "026ahhvpj5pksy90f8pnxgmhgwfqk4kwyvcf8x3dsanvz98d4pj5";
          })
          # Drop support for Coq < 8.9
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/7563a5df926a4c6fb1489a7a4c847641c8a35095.patch";
            sha256 = "05vkslzy399r3dm6dmjs722rrajnyfa30xsyy3djl52isvn4gyfb";
          })
          # Support for Coq 8.13.2
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/48bc183167c4ce01a5c9ea86e49d60530adf7290.patch";
            sha256 = "0j62lppfk26d1brdp3qwll2wi4gvpx1k70qivpvby5f7dpkrkax1";
          })
        ];
      }
      { cases = [ (range "8.14" "8.15") "3.10" ];
        out = [
          # Support for Coq 8.14.1
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/a79f0f99831aa0b0742bf7cce459cc9353bd7cd0.patch";
            sha256 = "sha256:0g20x8gfzvplpad9y9vr1p33k6qv6rsp691x6687v9ffvz7zsz94";
          })
          # Support for Coq 8.15.0
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/a882f78c069f7337dd9f4abff117d4df98ef38a6.patch";
            sha256 = "sha256:16i87s608fj9ni7cvd5wrd7gicqniad7w78wi26pxdy0pacl7bjg";
          })
          # Support for Coq 8.15.1
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/10a976994d7fd30d143354c289ae735d210ccc09.patch";
            sha256 = "sha256:0bg58gpkgxlmxzp6sg0dvybrfk0pxnm7qd6vxlrbsbm2w6wk03jv";
          })
          # Support for Coq 8.15.2
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/283a5be7296c4c0a94d863b427c77007ab875733.patch";
            sha256 = "sha256:1s7hvb5ii3p8kkcjlzwldvk8xc3iiibxi9935qjbrh25xi6qs66k";
          })
        ];
      }
    ] [];
  }
)
