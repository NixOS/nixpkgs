{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (final: prev: {
  pname = "chroma";
  version = "0.2.7";
  src = fetchFromGitHub {
    owner = "treeform";
    repo = "chroma";
    rev = final.version;
    hash = "sha256-QSl8n60HO56kJ4BKKe/FjUC/cRNxqL2L56FqPwhmJl4=";
  };
  meta = final.src.meta // {
    description = "Everything you want to do with colors";
    homepage = "https://github.com/treeform/chroma";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
