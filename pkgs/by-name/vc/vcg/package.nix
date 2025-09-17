{
  lib,

  stdenv,
  fetchFromGitHub,

  # propagatedBuildInputs
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vcg";
  version = "2025.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "vcglib";
    tag = finalAttrs.version;
    hash = "sha256-OZnqFnHGXC9fS7JCLTiHNCeA//JBAZGLB5SP/rGzaA8=";
  };

  propagatedBuildInputs = [ eigen ];

  installPhase = ''
    mkdir -p $out/include
    cp -r vcg wrap $out/include
    find $out -name \*.h -exec sed -i 's,<eigenlib/,<eigen3/,g' {} \;
  '';

  meta = {
    homepage = "https://vcg.isti.cnr.it/vcglib/install.html";
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
