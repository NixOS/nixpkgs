{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yoga";
  version = "3.2.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "react";
    repo = "yoga";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y7tLHOfZ/S5ZAdtL8TXTNMwj76QH+alYBaI8e3Wc4iU=";
  };

  buildInputs = [ gtest ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./yoga-find-gtest.patch ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=array-bounds"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Yoga is an embeddable layout engine targeting web standards.";
    homepage = "https://github.com/react/yoga";
    license = licenses.mit;
    maintainers = with maintainers; [ arntanguy ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
