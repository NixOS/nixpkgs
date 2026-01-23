{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tweeny";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mobius3";
    repo = "tweeny";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9nFEI4gignIJaBFW9GDuSJJqeWli6YcKs/uYEL89VsE=";
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
