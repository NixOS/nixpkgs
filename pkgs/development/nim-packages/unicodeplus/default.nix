{ lib, buildNimPackage, fetchFromGitHub, segmentation }:

buildNimPackage (finalAttrs: {
  pname = "unicodeplus";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "nitely";
    repo = "nim-unicodeplus";
    rev = "v${finalAttrs.version}";
    sha256 = "181wzwivfgplkqn5r4crhnaqgsza7x6fi23i86djb2dxvm7v6qxk";
  };
  propagatedBuildInputs = [ segmentation ];
  meta = finalAttrs.src.meta // {
    description = "Common unicode operations";
    homepage = "https://github.com/nitely/nim-unicodeplus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
