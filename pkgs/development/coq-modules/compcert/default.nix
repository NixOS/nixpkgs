{ lib, fetchzip, mkCoqDerivation, coq, flocq, compcert
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
      { case = range "8.8" "8.11";  out = "3.7"; }
      { case = range "8.12" "8.13"; out = "3.8"; }
    ] null;

  release = {
    "3.7".sha256 = "1h4zhk9rrqki193nxs9vjvya7nl9yxjcf07hfqb6g77riy1vd2jr";
    "3.8".sha256 = "1gzlyxvw64ca12qql3wnq3bidcx9ygsklv9grjma3ib4hvg7vnr7";
    "3.9".sha256 = "1srcz2dqrvmbvv5cl66r34zqkm0hsbryk7gd3i9xx4slahc9zvdb";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with ocamlPackages; [ ocaml findlib menhir menhirLib ] ++ [ coq coq2html ];
  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace ./configure \
      --replace \$\{toolprefix\}ar 'ar' \
      --replace '{toolprefix}gcc' '{toolprefix}cc'
  '';

  installTargets = "documentation install";
  postInstall = ''
    # move man into place
    mkdir -p $man/share
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
  let useExternalFlocq = with lib.versions; range "3.8" "3.9" o.version; in
  {
    patches = with versions; switch [ coq.version o.version ] [
      { cases = [ (isEq "8.11") "3.7" ];
        out = [
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/0a2db0269809539ccc66f8ec73637c37fbd23580.patch";
            sha256 = "0n8qrba70x8f422jdvq9ddgsx6avf2dkg892g4ldh3jiiidyhspy";
          })
          (fetchpatch {
            url = "https://github.com/AbsInt/CompCert/commit/5e29f8b5ba9582ecf2a1d0baeaef195873640607.patch";
            sha256 = "184nfdgxrkci880lkaj5pgnify3plka7xfgqrgv16275sqppc5hc";
          })
        ];
      }
      { cases = [ (range "8.12" "8.13") "3.8" ];
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
    ] [];

    propagatedBuildInputs = optional useExternalFlocq [ flocq ];

    configurePhase = ''
      ./configure -clightgen \
      -prefix $out \
      -coqdevdir $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/ \
      -toolprefix ${tools}/bin/ \
      ${optionalString useExternalFlocq "-use-external-Flocq"} \
      ${if stdenv.isDarwin then "x86_64-macosx" else "x86_64-linux"}
    '';
  }
)
