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

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.57";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "refs/tags/v${version}";
    hash = "sha256-jAGJEXNDclcGHnoDYMjQXz5ZS9U9pmIWEHzgYKp49/o=";
  };

  postPatch = ''
    rm -r miniaudio
    ln -s ${miniaudio} miniaudio
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
