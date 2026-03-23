{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.19.0";
  pname = "tini";

  src = fetchFromGitHub {
    owner = "krallin";
    repo = "tini";
    rev = "v${finalAttrs.version}";
    sha256 = "1hnnvjydg7gi5gx6nibjjdnfipblh84qcpajc08nvr44rkzswck4";
  };

  # Note: These patches can be removed with the next release
  patches = [
    (fetchpatch {
      url = "https://github.com/krallin/tini/commit/0b44d3665869e46ccbac7414241b8256d6234dc4.patch";
      hash = "sha256-gjM8MaPVx65f7KIry2XVYnVyjoBCQZAp2cQ8m7eW24c=";
    })
    (fetchpatch {
      url = "https://github.com/krallin/tini/commit/071c715e376e9ee0ac1a196fe8c38bcb61ad385c.patch";
      hash = "sha256-idnYcVuhCXQuhFSqcrNjbCLhR4HNlv8QonrtBqEbo3A=";
    })
    (fetchpatch {
      url = "https://github.com/krallin/tini/commit/924c4bd6028457188942ecbfdc75e6a343fa9395.patch";
      hash = "sha256-i6xcf+qpjD+7ZQY3ueiDaxO4+UA2LutLCZLNmT+ji1s=";
    })
  ];

  postPatch = "sed -i /tini-static/d CMakeLists.txt";

  env.NIX_CFLAGS_COMPILE = "-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Tiny but valid init for containers";
    homepage = "https://github.com/krallin/tini";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "tini";
  };
})
