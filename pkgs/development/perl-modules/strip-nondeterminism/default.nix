{
  lib,
  stdenv,
  file,
  fetchFromGitLab,
  buildPerlPackage,
  ArchiveZip,
  ArchiveCpio,
  SubOverride,
  shortenPerlShebang,
}:

buildPerlPackage rec {
  pname = "strip-nondeterminism";
  version = "1.13.1";

  outputs = [
    "out"
    "dev"
  ]; # no "devdoc"

  src = fetchFromGitLab {
    owner = "reproducible-builds";
    repo = "strip-nondeterminism";
    domain = "salsa.debian.org";
    rev = version;
    sha256 = "czx9UhdgTsQSfDNo1mMOXCM/3/nuNe+cPZeyy2xdnKs=";
  };

  strictDeps = true;
  nativeBuildInputs = lib.optionals stdenv.isDarwin [ shortenPerlShebang ];
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

  postInstall =
    ''
      # we don’t need the debhelper script
      rm $out/bin/dh_strip_nondeterminism
      rm $out/share/man/man1/dh_strip_nondeterminism.1
    ''
    + lib.optionalString stdenv.isDarwin ''
      shortenPerlShebang $out/bin/strip-nondeterminism
    '';

  installCheckPhase = ''
    runHook preInstallCheck
    ($out/bin/strip-nondeterminism --help 2>&1 | grep -q "verbose") || (echo "'$out/bin/strip-nondeterminism --help' failed" && exit 1)
    runHook postInstallCheck
  '';

  # running shortenPerlShebang in postBuild results in non-functioning binary 'exec format error'
  doCheck = !stdenv.isDarwin;
  doInstallCheck = true;

  meta = with lib; {
    description = "A Perl module for stripping bits of non-deterministic information";
    mainProgram = "strip-nondeterminism";
    homepage = "https://reproducible-builds.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      pSub
      artturin
    ];
  };
}
