# This file tracks the Clojure tools version required by babashka.
# See https://github.com/borkdude/deps.clj#deps_clj_tools_version for background.
# The `updateScript` provided in default.nix takes care of keeping it in sync, as well.
{
  clojure,
  fetchurl,
}:
clojure.overrideAttrs (previousAttrs: {
  pname = "babashka-clojure-tools";
  version = "1.12.4.1597";

  src = fetchurl {
    url = previousAttrs.src.url;
    hash = "sha256-DgEvXVExaexDTLoonh/fVS5nHjgekL6BlFYLM9X6wkM=";
  };
})
