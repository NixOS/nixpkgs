# This file tracks the Clojure tools version required by babashka.
# See https://github.com/borkdude/deps.clj#deps_clj_tools_version for background.
# The `updateScript` provided in default.nix takes care of keeping it in sync, as well.
{ clojure
, fetchurl
}:
clojure.overrideAttrs (previousAttrs: {
  pname = "babashka-clojure-tools";
  version = "1.11.3.1463";

  src = fetchurl {
    url = previousAttrs.src.url;
    hash = "sha256-26QZ3j54XztpW2WJ1xg0Gc+OwrsvmfK4iv0GsLV8FIc=";
  };
})
