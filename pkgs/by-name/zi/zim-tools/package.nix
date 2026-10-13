{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  docopt_cpp,
  file,
  gumbo,
  mustache-hpp,
  libzim,
  icu,
  zlib,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zim-tools";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "zim-tools";
    tag = finalAttrs.version;
    hash = "sha256-8+/3+FOq35FSYzpQdpqs5MTMtUO5SYbKLPECFi+IIKw=";
  };

  patches = [
    # Took from:
    # https://gitlab.archlinux.org/archlinux/packaging/packages/zim-tools/-/blob/0b4ffc61be76f1cfc61500f8157f99e28bb3c7b1/0001-Fix-build-with-ICU-76.patch
    # https://github.com/openzim/libzim/pull/936
    ./fix_build_with_icu76.patch
  ];

  postPatch = ''
    # Disable werror, since the use of deprecated functions in libzim causes the build to fail
    substituteInPlace meson.build \
      --replace-fail "'werror=true', " ""
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    docopt_cpp
    file
    gumbo
    mustache-hpp
    libzim
    icu
    zlib
  ];

  nativeCheckInputs = [ gtest ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Various ZIM command line tools";
    homepage = "https://github.com/openzim/zim-tools";
    maintainers = with lib.maintainers; [ robbinch ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
