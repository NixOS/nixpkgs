{
  lib,
  stdenv,
  fetchurl,
  trousers,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tpm-quote-tools";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/tpmquotetools/${finalAttrs.version}/tpm-quote-tools-${finalAttrs.version}.tar.gz";
    sha256 = "1qjs83xb4np4yn1bhbjfhvkiika410v8icwnjix5ad96w2nlxp0h";
  };

  buildInputs = [
    trousers
    openssl
  ];

  postFixup = ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath [ openssl ]}:$(patchelf --print-rpath $out/bin/tpm_mkaik)" \
      $out/bin/tpm_mkaik
  '';

  meta = {
    description = "Collection of programs that provide support for TPM based attestation using the TPM quote mechanism";
    longDescription = ''
      The TPM Quote Tools is a collection of programs that provide support
      for TPM based attestation using the TPM quote mechanism.  The manual
      page for tpm_quote_tools provides a usage overview.
    '';
    homepage = "http://tpmquotetools.sourceforge.net/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ak ];
    platforms = lib.platforms.linux;
  };
})
