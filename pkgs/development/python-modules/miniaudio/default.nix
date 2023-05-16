{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, miniaudio
, cffi
, pytestCheckHook
, AudioToolbox
, CoreAudio
}:

<<<<<<< HEAD
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
  version = "1.59";
=======
buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.56";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-tMQOGqEThtownW3cnNpCzWye0Uo/Es7E8abVySo1QnQ=";
=======
    hash = "sha256-vNh9BupU6T+Gfa8fdt8r3/vqtTtfVDyrxM9GkFUcDcI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    rm -r miniaudio
<<<<<<< HEAD
    ln -s ${miniaudio'} miniaudio
=======
    ln -s ${miniaudio} miniaudio
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace build_ffi_module.py \
      --replace "miniaudio/stb_vorbis.c" "miniaudio/extras/stb_vorbis.c";
    substituteInPlace miniaudio.c \
      --replace "miniaudio/stb_vorbis.c" "miniaudio/extras/stb_vorbis.c";
  '';

  buildInputs = lib.optionals stdenv.isDarwin [
    AudioToolbox
    CoreAudio
  ];

  propagatedNativeBuildInputs = [ cffi ];
  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "miniaudio" ];

  meta = with lib; {
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
