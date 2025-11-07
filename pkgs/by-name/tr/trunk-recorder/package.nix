{
  lib,
  stdenv,
  fetchFromGitHub,
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
stdenv.mkDerivation rec {
  pname = "trunk-recorder";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "robotastic";
    repo = "trunk-recorder";
    rev = "v${version}";
    hash = "sha256-UTowlW2xKJllYlEvfEVQEyjNmFX3oafKJThIYDx7dkc=";
  };

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
    changelog = "https://github.com/robotastic/trunk-recorder/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ PapayaJackal ];
    mainProgram = "trunk-recorder";
  };
}
