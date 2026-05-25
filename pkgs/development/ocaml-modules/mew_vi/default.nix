{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  mew,
  react,
}:

buildDunePackage (finalAttrs: {
  pname = "mew_vi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kandu";
    repo = "mew_vi";
    tag = finalAttrs.version;
    hash = "sha256-KI8yZGCYvKN59krpxBLBVNLZKoe1cGCoVr9MIZBbMFI=";
  };

  propagatedBuildInputs = [
    mew
    react
  ];

  meta = {
    homepage = "https://github.com/kandu/mew_vi";
    license = lib.licenses.mit;
    description = "Modal Editing Witch, VI interpreter";
    maintainers = [ lib.maintainers.vbgl ];
  };

})
