{
  tpm2-pkcs11,
  ...
}@args:

tpm2-pkcs11.override (
  args
  // {
    fapiSupport = false;
    extraDescription = "Disables FAPI support, as if TPM2_PKCS11_BACKEND were always set to 'esysdb'.";
  }
)
