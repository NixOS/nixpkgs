{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wait4x";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Cv0yjkfxJQFTcDLyAgWnjIz4mfZY1T99X1j7N6lL7zA=";
  };

  vendorHash = "sha256-4OlAA032PMfn03zOiQA2aw0jqUKm/US86wwSLpfrQOk=";

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
