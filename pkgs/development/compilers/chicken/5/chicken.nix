{ lib, stdenv, fetchurl, makeWrapper, darwin, bootstrap-chicken ? null }:

let
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if (isFreeBSD || isOpenBSD) then "bsd"
    else if isSunOS then "solaris"
    else "linux"; # Should be a sane default
in
stdenv.mkDerivation rec {
  pname = "chicken";
  version = "5.3.0";

  binaryVersion = 11;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${version}/chicken-${version}.tar.gz";
    sha256 = "sha256-w62Z2PnhftgQkS75gaw7DC4vRvsOzAM7XDttyhvbDXY=";
  };

  setupHook = lib.optional (bootstrap-chicken != null) ./setup-hook.sh;

  # -fno-strict-overflow is not a supported argument in clang on darwin
  hardeningDisable = lib.optionals stdenv.isDarwin ["strictoverflow"];

  makeFlags = [
    "PLATFORM=${platform}" "PREFIX=$(out)"
  ] ++ (lib.optionals stdenv.isDarwin [
    "XCODE_TOOL_PATH=${darwin.binutils.bintools}/bin"
    "C_COMPILER=$(CC)"
  ]);

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = lib.optionals (bootstrap-chicken != null) [
    bootstrap-chicken
  ];

  postInstall = ''
    for f in $out/bin/*
    do
      wrapProgram $f \
        --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
    done
  '';

  doCheck = !stdenv.isDarwin;
  postCheck = ''
    ./csi -R chicken.pathname -R chicken.platform \
       -p "(assert (equal? \"${toString binaryVersion}\" (pathname-file (car (repository-path)))))"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/chicken -version
  '';

  meta = {
    homepage = "https://call-cc.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ corngood ];
    platforms = lib.platforms.unix;
    description = "A portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R5RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, macOS,
      Windows, and many Unix flavours.
    '';
  };
}
