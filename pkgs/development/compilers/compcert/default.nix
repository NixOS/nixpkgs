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
