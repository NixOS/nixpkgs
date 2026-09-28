{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin (finalAttrs: {
  pname = "compress.yazi";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "KKV9";
    repo = "compress.yazi";
    tag = "0.6";
    hash = "sha256-Mby185FCJY6nqHcHDQu+D5SLk+wGcyeUHK8yAvrd4TM=";
  };

  meta = {
    description = "Yazi plugin that compresses selected files to an archive";
    homepage = "https://github.com/KKV9/compress.yazi";
    changelog = "https://github.com/KKV9/compress.yazi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
