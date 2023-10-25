{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (finalAttrs: {
  pname = "noise";
  version = "0.1.8";
  src = fetchFromGitHub {
    owner = "jangko";
    repo = "nim-noise";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QD7X1QTAKHYa2+QiYjrQq74CnEafwq/RsshlW2yZqmI=";
  };
  meta = finalAttrs.src.meta // {
    description = "Nim implementation of linenoise";
    homepage = "https://github.com/jangko/nim-noise";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
