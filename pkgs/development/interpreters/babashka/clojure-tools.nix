# This file tracks the Clojure tools version required by babashka.
# See https://github.com/borkdude/deps.clj#deps_clj_tools_version for background.
# The `updateScript` provided in default.nix takes care of keeping it in sync, as well.
{ clojure
, fetchurl
}:
clojure.overrideAttrs (previousAttrs: {
  pname = "babashka-clojure-tools";
  version = "1.11.1.1413";

  src = fetchurl {
    url = previousAttrs.src.url;
    hash = "sha256-k8Olo63KUcWFgGNBmr9myD2/JOoV4f2S95v35mI4H+A=";
  };
})
