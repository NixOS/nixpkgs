{
  lib,
  stdenv,
  hareHook,
  hareThirdParty,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-png";
  version = "0-unstable-2024-03-13";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-png";
    rev = "5ae7bc7f6caa6f89dcfd8e3ebed717b50c35e085";
    hash = "sha256-DVXTlM3f5G5Zsra7KJn8++mmrEhAOr7q0kA4Ep66VKw=";
  };

  nativeBuildInputs = [ hareHook ];
  propagatedBuildInputs = [ hareThirdParty.hare-compress ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-png/";
    description = "PNG implementation for Hare";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ starzation ];
    inherit (hareHook.meta) platforms badPlatforms;
    broken = true; # hare 0.26.0
  };
})
