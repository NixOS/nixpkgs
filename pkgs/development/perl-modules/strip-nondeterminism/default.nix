{
  lib,
  stdenv,
  file,
  fetchFromGitLab,
  buildPerlPackage,
  ArchiveZip,
  ArchiveCpio,
  SubOverride,
<<<<<<< HEAD
=======
  shortenPerlShebang,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ shortenPerlShebang ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/strip-nondeterminism
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    ($out/bin/strip-nondeterminism --help 2>&1 | grep -q "verbose") || (echo "'$out/bin/strip-nondeterminism --help' failed" && exit 1)
    runHook postInstallCheck
  '';

<<<<<<< HEAD
=======
  # running shortenPerlShebang in postBuild results in non-functioning binary 'exec format error'
  doCheck = !stdenv.hostPlatform.isDarwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

<<<<<<< HEAD
  meta = {
    description = "Perl module for stripping bits of non-deterministic information";
    mainProgram = "strip-nondeterminism";
    homepage = "https://reproducible-builds.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Perl module for stripping bits of non-deterministic information";
    mainProgram = "strip-nondeterminism";
    homepage = "https://reproducible-builds.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      pSub
      artturin
    ];
  };
}
