{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  testers,
  uasm,
}:

stdenv.mkDerivation rec {
  pname = "uasm";
  version = "2.56.2";

  src = fetchFromGitHub {
    owner = "Terraspace";
    repo = pname;
    # Specifying only the tag results in the following error during download:
    # the given path has multiple possibilities: #<Git::Ref:0x00007f618689c378>, #<Git::Ref:0x00007f618689c1e8>
    # Probably because upstream has both a tag and a branch with the same name
    rev = "refs/tags/v${version}";
    hash = "sha256-QiRBscY6zefeLDDVhS/+j9yIJ+5QhgkDQh1CLl/CslM=";
  };

  patches = [
    (fetchpatch {
      name = "fix-v2_55-compilation-on-macos.patch";
      url = "https://github.com/Terraspace/UASM/commit/b50c430cc3083c7f32e288a9f64fe1cafb03091d.patch";
      sha256 = "sha256-FGFB282LSEKtGD1cIRH+Qi5bye5Gx4xb0Ty4J03xjCU";
    })
  ];

  enableParallelBuilding = true;

  makefile = if stdenv.isDarwin then "ClangOSX64.mak" else "gccLinux64.mak";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" -m0755 GccUnixR/uasm
    install -Dt "$out/share/doc/${pname}" -m0644 {Readme,History}.txt Doc/*

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = uasm;
    command = "uasm -h";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://www.terraspace.co.uk/uasm.html";
    description = "Free MASM-compatible assembler based on JWasm";
    mainProgram = "uasm";
    platforms = platforms.unix;
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.watcom;
  };
}
