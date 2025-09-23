{
  _cuda,
  backendStdenv,
  cudnn,
}:
let
  version = if backendStdenv.hasJetsonCudaCapability then "8.9.5" else "8.9.7";
in
# TODO(@connorbaker): Support for old versions of CUDNN should be removed.
cudnn.overrideAttrs (prevAttrs: {
  passthru = prevAttrs.passthru // {
    release = _cuda.manifests.cudnn.${version}.cudnn;
  };
})
