{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wait4x";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5RfN51BwsTOZeg/O8qfk/mUKwdf9z36da+vl0NJlYPU=";
  };

  vendorHash = "sha256-3Wvtk05zLyJZCpdvAMlypL6JRn08S2rqm/n8JLxXJI8=";

  # Tests make network access
  doCheck = false;

  meta = {
    description = "Allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/wait4x/wait4x";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
})
