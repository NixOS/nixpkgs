{
  lib,
  stdenv,
  file,
  fetchFromGitLab,
  buildPerlPackage,
  ArchiveZip,
  ArchiveCpio,
  SubOverride,
  gitUpdater,
}:

buildPerlPackage rec {
  pname = "strip-nondeterminism";
  version = "1.14.1";

  outputs = [
    "out"
    "dev"
  ]; # no "devdoc"

  src = fetchFromGitLab {
    owner = "reproducible-builds";
    repo = "strip-nondeterminism";
    domain = "salsa.debian.org";
    rev = version;
    sha256 = "C/812td9BX1YRqFpD9QYgBfzE+biZeAKgxoNcxpb6UU=";
  };

  strictDeps = true;
  buildInputs = [
    ArchiveZip
    ArchiveCpio
    SubOverride
  ];

  postPatch = ''
    substituteInPlace lib/File/StripNondeterminism.pm \
      --replace "exec('file'" "exec('${lib.getExe file}'"
  '';

  postBuild = ''
    patchShebangs ./bin
  '';

  postInstall = ''
    # we don’t need the debhelper script
    rm $out/bin/dh_strip_nondeterminism
    rm $out/share/man/man1/dh_strip_nondeterminism.1
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    ($out/bin/strip-nondeterminism --help 2>&1 | grep -q "verbose") || (echo "'$out/bin/strip-nondeterminism --help' failed" && exit 1)
    runHook postInstallCheck
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Perl module for stripping bits of non-deterministic information";
    mainProgram = "strip-nondeterminism";
    homepage = "https://reproducible-builds.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pSub
      artturin
    ];
  };
}
