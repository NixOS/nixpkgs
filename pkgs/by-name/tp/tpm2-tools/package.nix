{
  stdenv,
  fetchurl,
  lib,
  pandoc,
  pkg-config,
  makeWrapper,
  curl,
  openssl,
  tpm2-tss,
  libuuid,
  abrmdSupport ? true,
  tpm2-abrmd ? null,
}:

stdenv.mkDerivation rec {
  pname = "tpm2-tools";
  version = "5.7";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-OBDTa1B5JW9PL3zlUuIiE9Q7EDHBMVON+KLbw8VwmDo=";
  };

  nativeBuildInputs = [
    pandoc
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    curl
    openssl
    tpm2-tss
    libuuid
  ];

  preFixup =
    let
      ldLibraryPath = lib.makeLibraryPath (
        [
          tpm2-tss
        ]
        ++ (lib.optional abrmdSupport tpm2-abrmd)
      );
    in
    ''
      wrapProgram $out/bin/tpm2 --suffix LD_LIBRARY_PATH : "${ldLibraryPath}"
      wrapProgram $out/bin/tss2 --suffix LD_LIBRARY_PATH : "${ldLibraryPath}"
    '';

  # Unit tests disabled, as they rely on a dbus session
  #configureFlags = [ "--enable-unit" ];
  doCheck = false;

  meta = with lib; {
    description = "Command line tools that provide access to a TPM 2.0 compatible device";
    homepage = "https://github.com/tpm2-software/tpm2-tools";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tomfitzhenry ];
  };
}
