{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  git,
  makeWrapper,
  pkg-config,
  boost,
  curl,
  gmp,
  gnuradio,
  gnuradioPackages,
  hackrf,
  mpir,
  openssl,
  spdlog,
  uhd,
  volk,
  fdk-aac-encoder,
  sox,
  hackrfSupport ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "trunk-recorder";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "TrunkRecorder";
    repo = "trunk-recorder";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cLreyYLPIMPLYBcsj8QUukbeRnIMIEF3VSTTg9AOumM=";
  };

  patches = [
    # Fixes build with boost 1.89, reported here:
    # https://github.com/TrunkRecorder/trunk-recorder/issues/1140 and fixed in
    # https://github.com/TrunkRecorder/trunk-recorder/commit/a7810f36fd3c1e0fb61877f5b8e02a1376f01635
    (fetchpatch {
      url = "https://github.com/TrunkRecorder/trunk-recorder/commit/a7810f36fd3c1e0fb61877f5b8e02a1376f01635.patch";
      hash = "sha256-AB0EPHnJJwwHrz59mNlOcyAFOgzisYI0cJOnHjeu3V4=";
    })
  ];

  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=ON" ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    boost
    curl
    gmp
    gnuradio
    gnuradioPackages.osmosdr
    openssl
    spdlog
    uhd
    volk
  ]
  ++ lib.optionals hackrfSupport [ hackrf ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ mpir ];

  postPatch = ''
    # fix broken symlink
    rm -v trunk-recorder/git.h
    cp -v git.h trunk-recorder/git.h
  '';

  postFixup = ''
    wrapProgram $out/bin/trunk-recorder --prefix PATH : ${
      lib.makeBinPath [
        sox
        fdk-aac-encoder
      ]
    }
  '';

  meta = {
    description = "Record calls from trunked radio systems";
    homepage = "https://trunkrecorder.com/";
    changelog = "https://github.com/TrunkRecorder/trunk-recorder/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ PapayaJackal ];
    mainProgram = "trunk-recorder";
  };
})
