{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "tomlcpp";
  version = "0.pre+date=2022-06-25";

  src = fetchFromGitHub {
    owner = "cktan";
    repo = "tomlcpp";
    rev = "4212f1fccf530e276a2e1b63d3f99fbfb84e86a4";
    hash = "sha256-PM3gURXhyTZr59BWuLHvltjKOlKUSBT9/rqTeX5V//k=";
  };

  patches = [
    (fetchpatch {
      # Use implicit $AR variable in Makefile
      # https://github.com/cktan/tomlcpp/pull/6
      url = "https://github.com/cktan/tomlcpp/commit/abdb4e0db8b27f719434f5a0d6ec0b1a6b086ded.patch";
      hash = "sha256-SurUKdAZNWqBC7ss5nv5mDnJyC3DqxG/Q/FweTrkLnk=";
    })
  ];

  dontConfigure = true;

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = {
    homepage = "https://github.com/cktan/tomlcpp";
    description = "No fanfare TOML C++ Library";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
}
