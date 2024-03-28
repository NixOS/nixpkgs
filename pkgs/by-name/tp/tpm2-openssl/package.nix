{ stdenv
, lib
, autoreconfHook
, fetchFromGitHub
, gitUpdater
, autoconf-archive
, pkg-config
, openssl
, tpm2-tss
}: stdenv.mkDerivation (finalAttrs: {
  pname = "tpm2-openssl";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = "tpm2-openssl";
    rev = finalAttrs.version;
    hash = "sha256-mZ4Z/GxJFwwfyFd1SAiVlQqOjkFSzsZePeuEZtq8Mcg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    openssl
    tpm2-tss
  ];

  preConfigurePhases = [
    "setConfigureFlags"
  ];

  setConfigureFlags = ''
    export configureFlags="$configureFlags --with-modulesdir=$out/lib/ossl-modules"
  '';

  prePatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "OpenSSL Provider for TPM2 integration";
    homepage = "https://github.com/tpm2-software/tpm2-openssl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
})
