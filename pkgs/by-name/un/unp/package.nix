{
  stdenv,
  lib,
  fetchFromGitLab,
  installShellFiles,
  makeWrapper,
  perl,
  unzip,
  gzip,
  file,
  # extractors which are added to unp’s PATH
  extraBackends ? [ ],
}:

let
  runtime_bins = [
    file
    unzip
    gzip
  ]
  ++ extraBackends;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "unp";
  version = "2.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "blade";
    repo = "unp";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-6lYyKnNUkz9PKdn++zHe2SMdFsgaajStIdSaenbXIRo=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [ perl ];

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installBin unp ucat
    installManPage debian/unp.1
    wrapProgram $out/bin/unp \
      --prefix PATH : ${lib.makeBinPath runtime_bins}
    wrapProgram $out/bin/ucat \
      --prefix PATH : ${lib.makeBinPath runtime_bins}

    runHook postInstall
  '';

  meta = {
    description = "Command line tool for unpacking archives easily";
    homepage = "https://packages.qa.debian.org/u/unp.html";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = [ lib.maintainers.timor ];
    platforms = lib.platforms.all;
  };
})
