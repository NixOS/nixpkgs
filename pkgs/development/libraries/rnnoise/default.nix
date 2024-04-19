{ stdenv, lib, fetchFromGitLab, fetchurl, autoreconfHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "rnnoise";
  version = "0.2";

  src = fetchFromGitLab {
    domain = "gitlab.xiph.org";
    owner = "xiph";
    repo = "rnnoise";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qaf+0iOprq7ILRWNRkBjsniByctRa/lFVqiU5ZInF/Q=";
  };

  # Copy from https://gitlab.xiph.org/xiph/rnnoise/-/raw/v${finalAttrs.version}/model_version
  model_version = "0b50c45";
  model = fetchurl {
    url = "https://media.xiph.org/rnnoise/models/rnnoise_data-${finalAttrs.model_version}.tar.gz";
    hash = "sha256-SsgcXAiE7EvVkHAmqq4WIJt7ds2df3GvWCCUovmPS0M=";
  };

  patchPhase = ''
    tar xvomf ${finalAttrs.model}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dt $out/bin examples/.libs/rnnoise_demo
  '';

  meta = {
    description = "Recurrent neural network for audio noise reduction";
    homepage = "https://people.xiph.org/~jm/demo/rnnoise/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nh2 ];
    mainProgram = "rnnoise_demo";
    platforms = lib.platforms.all;
  };
})
