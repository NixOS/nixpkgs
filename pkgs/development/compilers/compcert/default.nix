{ lib, stdenv, fetchFromGitHub, fetchpatch, makeWrapper
, coqPackages, ocamlPackages, coq2html
, tools ? stdenv.cc
, version ? "3.8"
}:

let
  ocaml-pkgs      = with ocamlPackages; [ ocaml findlib menhir ];
  ccomp-platform = if stdenv.isDarwin then "x86_64-macosx" else "x86_64-linux";
  inherit (coqPackages) coq flocq;
  inherit (lib) optional optionalString;
in

let param = {
  "3.7" = {
    sha256 = "1h4zhk9rrqki193nxs9vjvya7nl9yxjcf07hfqb6g77riy1vd2jr";
    patches = [
     (fetchpatch {
        url = "https://github.com/AbsInt/CompCert/commit/0a2db0269809539ccc66f8ec73637c37fbd23580.patch";
        sha256 = "0n8qrba70x8f422jdvq9ddgsx6avf2dkg892g4ldh3jiiidyhspy";
      })
     (fetchpatch {
        url = "https://github.com/AbsInt/CompCert/commit/5e29f8b5ba9582ecf2a1d0baeaef195873640607.patch";
        sha256 = "184nfdgxrkci880lkaj5pgnify3plka7xfgqrgv16275sqppc5hc";
      })
    ];
  };
  "3.8" = {
    sha256 = "1gzlyxvw64ca12qql3wnq3bidcx9ygsklv9grjma3ib4hvg7vnr7";
    patches = [
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
    useExternalFlocq = true;
  };
}."${version}"; in

stdenv.mkDerivation rec {
  pname = "compcert";
  inherit version;

  src = fetchFromGitHub {
    owner = "AbsInt";
    repo = "CompCert";
    rev = "v${version}";
    inherit (param) sha256;
  };

  patches = param.patches or [];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = ocaml-pkgs ++ [ coq coq2html ];
  propagatedBuildInputs = optional (param.useExternalFlocq or false) flocq;
  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace ./configure \
      --replace '{toolprefix}gcc' '{toolprefix}cc'
  '';

  configurePhase = ''
    ./configure -clightgen \
      -prefix $out \
      -coqdevdir $lib/lib/coq/${coq.coq-version}/user-contrib/compcert/ \
      -toolprefix ${tools}/bin/ \
      ${optionalString (param.useExternalFlocq or false) "-use-external-Flocq"} \
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
}
