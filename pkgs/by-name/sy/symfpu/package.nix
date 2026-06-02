{
  lib,
  stdenv,
  fetchFromGitHub,
  copyPkgconfigItems,
  makePkgconfigItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "symfpu";
  version = "0-unstable-2019-05-17";

  src = fetchFromGitHub {
    owner = "martin-cs";
    repo = "symfpu";
    rev = "8fbe139bf0071cbe0758d2f6690a546c69ff0053";
    sha256 = "1jf5lkn67q136ppfacw3lsry369v7mdr1rhidzjpbz18jfy9zl9q";
  };

  nativeBuildInputs = [ copyPkgconfigItems ];

  pkgconfigItems = [
    (makePkgconfigItem {
      name = "symfpu";
      inherit (finalAttrs) version;
      cflags = [ "-I\${includedir}" ];
      variables = {
        includedir = "@includedir@";
      };
      inherit (finalAttrs.meta) description;
    })
  ];

  env = {
    # copyPkgconfigItems will substitute this in the pkg-config file
    includedir = "${placeholder "out"}/include";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/symfpu
    cp -r * $out/include/symfpu/

    runHook postInstall
  '';

  meta = {
    description = "Implementation of SMT-LIB / IEEE-754 operations in terms of bit-vector operations";
    homepage = "https://github.com/martin-cs/symfpu";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shadaj ];
  };
})
