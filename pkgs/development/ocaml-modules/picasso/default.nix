{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  apronext,
}:

buildDunePackage (finalAttrs: {
  pname = "picasso";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "ghilesZ";
    repo = "picasso";
    tag = finalAttrs.version;
    hash = "sha256-VYrN77IVXPdzPV1CNe5N4D2jgrVIHJFMvfRP6cQq/eI=";
  };

  propagatedBuildInputs = [ apronext ];

  meta = {
    description = "An Abstract element drawing library";
    license = lib.licenses.lgpl2Plus;
    homepage = "https://github.com/ghilesZ/picasso";
  };
})
