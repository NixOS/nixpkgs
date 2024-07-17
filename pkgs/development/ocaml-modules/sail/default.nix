{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  base64,
  omd,
  menhir,
  ott,
  linenoise,
  dune-site,
  pprint,
  makeWrapper,
  lem,
  z3,
  linksem,
  num,
  yojson,
}:

buildDunePackage rec {
  pname = "sail";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "sail";
    rev = version;
    hash = "sha256-HY/rgWi0S7ZiAWZF0fVIRK6fpoJ7Xp5EQcxoPRCPJ5Y=";
  };

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [
    makeWrapper
    ott
    menhir
    lem
  ];

  propagatedBuildInputs = [
    base64
    omd
    dune-site
    linenoise
    pprint
    linksem
    yojson
  ];

  preBuild = ''
    rm -r aarch*  # Remove code derived from non-bsd2 arm spec
    rm -r snapshots  # Some of this might be derived from stuff in the aarch dir, it builds fine without it
  '';
  # `buildDunePackage` only builds the [pname] package
  # This doesnt work in this case, as sail includes multiple packages in the same source tree
  buildPhase = ''
    runHook preBuild
    dune build --release ''${enableParallelBuild:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';
  checkPhase = ''
    runHook preCheck
    dune runtest ''${enableParallelBuild:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';
  postInstall = ''
    wrapProgram $out/bin/sail --set SAIL_DIR $out/share/sail
  '';

  meta = with lib; {
    homepage = "https://github.com/rems-project/sail";
    description = "A language for describing the instruction-set architecture (ISA) semantics of processors";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd2;
  };
}
