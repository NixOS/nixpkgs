{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dsp56300";
  # No updateScript: xemu pins a specific version of this library (subprojects/dsp56300),
  # so update it together with xemu.
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "xemu-project";
    repo = "dsp56300";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a2j9kle2VMdSxDtTcfD3MmYtk0ZHgifJcrVNu7XNtMw=";
  };

  cargoHash = "sha256-d69CVAWP8oApgqYFnAFp9lehU4Eo0TrsSyaXOVii7UE=";

  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  # Upstream ships no pkg-config file; xemu looks the library up as dsp56300-emu-ffi
  postInstall = ''
    install -Dm644 crates/emu-ffi/include/dsp56300.h -t $dev/include
    install -Dm644 $out/lib/libdsp56300_emu_ffi.a -t $dev/lib
    rm -r $out/lib

    mkdir -p $dev/lib/pkgconfig
    cat > $dev/lib/pkgconfig/dsp56300-emu-ffi.pc <<EOF
    prefix=$dev
    libdir=\''${prefix}/lib
    includedir=\''${prefix}/include

    Name: dsp56300-emu-ffi
    Description: C FFI bindings for the DSP56300 emulator
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -ldsp56300_emu_ffi
    Libs.private: ${
      if stdenv.hostPlatform.isDarwin then "-lpthread -lm -framework Security" else "-lpthread -ldl -lm"
    }
    Cflags: -I\''${includedir}
    EOF
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Motorola DSP56300 assembler, disassembler and JIT emulator";
    homepage = "https://github.com/xemu-project/dsp56300";
    changelog = "https://github.com/xemu-project/dsp56300/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "dsp56300-emu";
    pkgConfigModules = [ "dsp56300-emu-ffi" ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
