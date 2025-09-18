{ lib, fetchFromGitHub }:

let

  # These packages are all part of the Swift toolchain, and have a single
  # upstream version that should match. We also list the hashes here so a basic
  # version upgrade touches only this file.
  version = "5.10";
  hashes = {
    llvm-project = "sha256-kmLVyChbDTCAgBz8oStbqZsFn36t0ihG0WRE1KuLtkk=";
    sourcekit-lsp = "sha256-mMZ8zPkyoht0aSSnStIULWbLjowahdza9DQXboT1D0o=";
    swift = "sha256-jHVbf1+eoP0ch1ffwOAugFQ2wGK5Aq++WQp4okXzvyc=";
    swift-cmark = "sha256-GK2tFu49Sw8jJWJpxQerVFqsuUJwkAhRloa2/aUTYB8=";
    swift-corelibs-foundation = "sha256-5MdYNyA7ES6Ef3O2sglthAykZh1HHsuFHsBZ2bHYdnQ=";
    swift-corelibs-libdispatch = "sha256-pta3wJj2LJ/lsYAWQpw0wSGLDMO41mN8Zbl78LUCaQo=";
    swift-corelibs-xctest = "sha256-Z1bsKG9gn63iGEFnUNsMcKxklodplD5boXLLh4ncAmI=";
    swift-docc = "sha256-zgGahAanYI95nQZ+3zAYrs0h4APNamPrZfwF81k1si0=";
    swift-docc-render-artifact = "sha256-Ky9l6tzAxQOpcPFq2FeGnFUl8i59TifRBSHNaZg8wfw=";
    swift-driver = "sha256-zTPobZ4M2jByrF9WxxuKmo6RYdykzTFqnNQCCpCXaaM=";
    swift-experimental-string-processing = "sha256-gv3xY9s6gdv0lpXH8RGfiLAvZWM7xVsUSLcqyb4rSeQ=";
    swift-format = "";
    swift-package-manager = "sha256-MVil4okklXwoK4oDmroKJUpzWofoJkk6qsaOO/NvJqw=";
    swift-syntax = "sha256-RCGItKBTBJonhH8bM4ln4cbFLru8ARgh63d5DhnoCOo=";
  };

  # Create fetch derivations.
  sources = lib.mapAttrs (
    repo: hash:
    fetchFromGitHub {
      owner = "apple";
      inherit repo;
      rev = "swift-${version}-RELEASE";
      name = "${repo}-${version}-src";
      hash = hashes.${repo};
    }
  ) hashes;

in
sources // { inherit version; }
