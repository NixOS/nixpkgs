{ lib, fetchFromGitHub }:

let

  # These packages are all part of the Swift toolchain, and have a single
  # upstream version that should match. We also list the hashes here so a basic
  # version upgrade touches only this file.
  version = "5.10.1";
  hashes = {
    llvm-project = "sha256-D+zZjLgnAFy6zBuUQwRI0VmDrgr2TQeNUnDbDtvtRZ4=";
    sourcekit-lsp = "sha256-mMZ8zPkyoht0aSSnStIULWbLjowahdza9DQXboT1D0o=";
    swift = "sha256-UK8yPwHu/sCvcuKKmBMCP9rGRJCZE3ct0ckdNw2BVbE=";
    swift-cmark = "sha256-GK2tFu49Sw8jJWJpxQerVFqsuUJwkAhRloa2/aUTYB8=";
    swift-corelibs-foundation = "sha256-izYpdCZaf3ktgz/k3pjmHJHH5BebdG7nj8l6vbuk+o0=";
    swift-corelibs-libdispatch = "sha256-pta3wJj2LJ/lsYAWQpw0wSGLDMO41mN8Zbl78LUCaQo=";
    swift-corelibs-xctest = "sha256-HgnVFYUuefCZKsOjXgt98ebMsLdMl0oXFXy2Pb2iUdw=";
    swift-docc = "sha256-zgGahAanYI95nQZ+3zAYrs0h4APNamPrZfwF81k1si0=";
    swift-docc-render-artifact = "sha256-Ky9l6tzAxQOpcPFq2FeGnFUl8i59TifRBSHNaZg8wfw=";
    swift-driver = "sha256-Xaz9gZuOspDb+PB67d6tXfpcs+kkDCPSkhu+eIfrb0A=";
    swift-experimental-string-processing = "sha256-gv3xY9s6gdv0lpXH8RGfiLAvZWM7xVsUSLcqyb4rSeQ=";
    swift-format = "sha256-oYf9Qt0b/6G3+uQaoExQRKzgpi1RPYSSpZLfwhuRmF8=";
    swift-package-manager = "sha256-yL/cPCt7pZ0XqbbxEnrbzM2X3EkU9klon7SzO2Z13SA=";
    swift-syntax = "sha256-OcrOdlnLYpMxH5CGWNGbs5XW3gJaGgKWQqB9YtwmZeY=";
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
