{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.50.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-7odcHOVjrj73suP0Uz8kcchvHqQxu0RVY0KwEQ73Tsw=";
  };

  npmDepsHash = "sha256-d0J7DPZaxn4ILMJ7rwf2MAVVCL2GI6/GLxkX78smUsU=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
