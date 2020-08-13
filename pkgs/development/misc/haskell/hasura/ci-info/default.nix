{ mkDerivation, aeson, aeson-casing, base, fetchgit, hashable
, hpack, stdenv, template-haskell, text, th-lift-instances
, unordered-containers
}:
mkDerivation {
  pname = "ci-info";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/hasura/ci-info-hs.git";
    sha256 = "0rn1799z4y7z1c6ijrr0gscarg25zmnfq0z9rrmk4ad727vf1ppc";
    rev = "6af5a68450347a02295a9cd050d05a8b2f5c06ab";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson aeson-casing base hashable template-haskell text
    th-lift-instances unordered-containers
  ];
  libraryToolDepends = [ hpack ];
  prePatch = "hpack";
  homepage = "https://github.com/hasura/ci-info-hs#readme";
  license = stdenv.lib.licenses.mit;
}
