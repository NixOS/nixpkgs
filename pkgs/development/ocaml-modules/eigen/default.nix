{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
  ctypes,
  dune-configurator,
}:

(buildDunePackage.override { inherit stdenv; }) (finalAttrs: {
  pname = "eigen";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "owlbarn";
    repo = "eigen";
    tag = finalAttrs.version;
    hash = "sha256-bi+7T9qXByVPIy86lBMiJ2LTKCoNesrKZPa3VEDyINA=";
  };

  propagatedBuildInputs = [ ctypes ];

  buildInputs = [ dune-configurator ];

  meta = {
    homepage = "https://github.com/owlbarn/eigen";
    description = "Minimal/incomplete Ocaml interface to Eigen3, mostly for Owl";
    platforms = lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ bcdarwin ];
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
