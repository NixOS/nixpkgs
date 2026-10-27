{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tweeny";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "mobius3";
    repo = "tweeny";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-foFS9ilPjseU4FAG6paPNkC5TY271f8QVgpcscbdUrs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    description = "Modern C++ tweening library";
    license = lib.licenses.mit;
    homepage = "http://mobius3.github.io/tweeny";
    maintainers = [ lib.maintainers.doronbehar ];
    platforms = with lib.platforms; darwin ++ linux;
  };
})
