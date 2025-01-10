{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  miniaudio,
  cffi,
  pytestCheckHook,
  AudioToolbox,
  CoreAudio,
}:

let
  # TODO: recheck after 1.59
  miniaudio' = miniaudio.overrideAttrs (oldAttrs: rec {
    version = "0.11.16"; # cffi breakage with 0.11.17
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      rev = "refs/tags/${version}";
      hash = "sha256-POe/dYPJ25RKNGIhaLoqxm9JJ08MrTyHVN4NmaGOdwM=";
    };
  });
in
buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.61";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "refs/tags/v${version}";
    hash = "sha256-H3o2IWGuMqLrJTzQ7w636Ito6f57WBtMXpXXzrZ7UD8=";
  };

  postPatch = ''
    rm -r miniaudio
    ln -s ${miniaudio'} miniaudio
    substituteInPlace build_ffi_module.py \
      --replace-fail "miniaudio/stb_vorbis.c" "miniaudio/extras/stb_vorbis.c";
    substituteInPlace miniaudio.c \
      --replace-fail "miniaudio/stb_vorbis.c" "miniaudio/extras/stb_vorbis.c";
  '';

  build-system = [ setuptools ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    AudioToolbox
    CoreAudio
  ];

  propagatedNativeBuildInputs = [ cffi ];
  dependencies = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "miniaudio" ];

  meta = with lib; {
    changelog = "https://github.com/irmen/pyminiaudio/releases/tag/v${version}";
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
