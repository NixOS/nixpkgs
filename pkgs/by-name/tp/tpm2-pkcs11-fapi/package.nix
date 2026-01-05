{
  tpm2-pkcs11,
  ...
}@args:

tpm2-pkcs11.override (
  args
  // {
    fapiSupport = true;
    defaultToFapi = true;
    extraDescription = "Enables fapi by default, as if TPM2_PKCS11_BACKEND defaulted to 'fapi'.";
  }
)
