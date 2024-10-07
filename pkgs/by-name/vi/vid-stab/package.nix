{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "vid.stab";
  version = "1.1.1-unstable-2024-06-15";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = pname;
    rev = "8dff7ad3c10ac663745f2263037f6e42b993519c";
    sha256 = "sha256-WqTNDGGAxP1pPZbZM6aU+2eJh+L0JqlOoySdx9ttoI8=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
