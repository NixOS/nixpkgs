{
  lib,
  gccStdenv,
  cudaPackages,
  fetchFromGitLab,
  config,
  cudaSupport ? config.cudaSupport,
  pkg-config,
  versionCheckHook,
}:

let
  stdenv = if cudaSupport then cudaPackages.backendStdenv else gccStdenv;
in
stdenv.mkDerivation rec {
  pname = "truecrack";
  version = "3.6";

  src = fetchFromGitLab {
    owner = "kalilinux";
    repo = "packages/truecrack";
    tag = "kali/${version}+git20150326-0kali4";
    hash = "sha256-d6ld6KHSqYM4RymHf5qcm2AWK6FHWC0rFaLRfIQ2m5Q=";
  };

  patches = [
    ./fix-empty-return.patch
    ./remove-opencc-options.patch
    ./set-cuda-archs.patch
  ];

  configureFlags = (
    if cudaSupport then
      [
        "--with-cuda=${cudaPackages.cudatoolkit}"
      ]
    else
      [
        "--enable-cpu"
      ]
  );

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
  ];

  env.NIX_CFLAGS_COMPILE = toString ([
    # Workaround build failure on -fno-common toolchains like upstream
    # gcc-10. Otherwise build fails as:
    #   ld: CpuAes.o:/build/source/src/Crypto/CpuAes.h:1233: multiple definition of
    #     `t_rc'; CpuCore.o:/build/source/src/Crypto/CpuAes.h:1237: first defined here
    # TODO: remove on upstream fixes it:
    #   https://gitlab.com/kalilinux/packages/truecrack/-/issues/1
    "-fcommon"
    # Function are declared after they are used in the file, this is error since gcc-14.
    #   Common/Crypto.c:42:13: error: implicit declaration of function 'cpu_CipherInit'; did you mean 'CipherInit'? []
    # https://gitlab.com/kalilinux/packages/truecrack/-/commit/5b0e3a96b747013bded7b33f65bb42be2dbafc86
    "-Wno-error=implicit-function-declaration"
  ]);

  enableParallelBuilding = true;

  installFlags = [ "prefix=$(out)" ];

  doInstallCheck = !cudaSupport;

  installCheckPhase = ''
    runHook preInstallCheck

    echo "Cracking test volumes"
    $out/bin/${meta.mainProgram} -t test/ripemd160_aes.test.tc -w test/passwords.txt | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/ripemd160_aes.test.tc -c test/tes -m 4 | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/ripemd160_aes.test.tc -w test/passwords.txt | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/whirlpool_aes.test.tc -w test/passwords.txt -k whirlpool | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/sha512_aes.test.tc -w test/passwords.txt -k sha512 | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/ripemd160_aes.test.tc -w test/passwords.txt | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/ripemd160_serpent.test.tc -w test/passwords.txt -e serpent | grep -aF "Found password"
    $out/bin/${meta.mainProgram} -t test/ripemd160_twofish.test.tc -w test/passwords.txt -e twofish | grep -aF "Found password"
    echo "Finished cracking test volumes"

    runHook postInstallCheck
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Brute-force password cracker for TrueCrypt volumes, optimized for Nvidia Cuda technology";
    mainProgram = "truecrack";
    homepage = "https://gitlab.com/kalilinux/packages/truecrack";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
