{ lib, stdenv, fetchurl, makeWrapper, darwin, bootstrap-chicken ? null, testers }:

let
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if (isFreeBSD || isOpenBSD) then "bsd"
    else if isSunOS then "solaris"
    else "linux"; # Should be a sane default
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chicken";
  version = "5.4.0";

  binaryVersion = 11;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${finalAttrs.version}/chicken-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-PF1KphwRZ79tm/nq+JHadjC6n188Fb8JUVpwOb/N7F8=";
  };

  # Disable two broken tests: "static link" and "linking tests"
  postPatch = ''
    sed -i tests/runtests.sh -e "/static link/,+4 { s/^/# / }"
    sed -i tests/runtests.sh -e "/linking tests/,+11 { s/^/# / }"
  '';

  setupHook = lib.optional (bootstrap-chicken != null) ./setup-hook.sh;

  # -fno-strict-overflow is not a supported argument in clang
  hardeningDisable = lib.optionals stdenv.cc.isClang [ "strictoverflow" ];

  makeFlags = [
    "PLATFORM=${platform}"
    "PREFIX=$(out)"
    "C_COMPILER=$(CC)"
    "CXX_COMPILER=$(CXX)"
  ] ++ (lib.optionals stdenv.isDarwin [
    "XCODE_TOOL_PATH=${darwin.binutils.bintools}/bin"
    "LINKER_OPTIONS=-headerpad_max_install_names"
    "POSTINSTALL_PROGRAM=install_name_tool"
  ]) ++ (lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "HOSTSYSTEM=${stdenv.hostPlatform.config}"
    "TARGET_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "TARGET_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ]);

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = lib.optionals (bootstrap-chicken != null) [
    bootstrap-chicken
  ];

  doCheck = !stdenv.isDarwin;
  postCheck = ''
    ./csi -R chicken.pathname -R chicken.platform \
       -p "(assert (equal? \"${toString finalAttrs.binaryVersion}\" (pathname-file (car (repository-path)))))"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "csi -version";
  };

  meta = {
    homepage = "https://call-cc.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ corngood nagy konst-aa ];
    platforms = lib.platforms.unix;
    description = "Portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R5RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, macOS,
      Windows, and many Unix flavours.
    '';
  };
})
