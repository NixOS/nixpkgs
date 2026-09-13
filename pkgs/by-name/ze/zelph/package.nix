{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-time
  cmake,
  janet,
  meson,
  ninja,
  pkg-config,

  # run-time
  bzip2,
  capnproto,
  mimalloc,
  unordered_dense,

  # tests
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zelph";
  version = "1.0.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "acrion";
    repo = "zelph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1bRgcYp9D9roNcerKpAc0yHCW9CmwFtI+rRxQxN+l7k=";
  };

  patches = [
    ./0001-Use-system-dependencies.patch
  ];

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    bzip2
    capnproto
    mimalloc
    unordered_dense
  ];

  preConfigure = ''
    cp -R ${janet.src} ./janet-src
    chmod -R u+w ./janet-src
    cmakeFlagsArray+=("-DJANET_SOURCE_DIR=$(pwd)/janet-src")
  '';

  checkInputs = [
    doctest
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    playground = callPackage ./playground.nix { };
  };

  meta = {
    description = "Semantic network system and reasoning engine";
    longDescription = ''
      zelph is a semantic network system and reasoning engine written in C++
      with an embedded Janet scripting layer.

      It treats logic, rules, and mathematics not as external code, but as
      [homoiconic structures](https://en.wikipedia.org/wiki/Homoiconicity) within the graph itself.

      By blending the flexibility of semantic webs (like Wikidata) with logic
      programming concepts (deep unification, constructive rules, negation as
      failure), zelph effectively transforms a static knowledge base into an
      executable graph.
    '';
    homepage = "https://github.com/acrion/zelph";
    changelog = "https://github.com/acrion/zelph/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "zelph";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
