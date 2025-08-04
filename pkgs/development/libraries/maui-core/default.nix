{
  lib,
  mkDerivation,
  libcanberra,
  pulseaudio,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  kio,
  kidletime,
}:

mkDerivation rec {
  pname = "maui-core";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-o0Xwh9w0cClMw85FwpQB9CNWoSnzARxs6aGfvCA4BhA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kidletime
    kio
    libcanberra
    pulseaudio
  ];

  meta = {
    description = "Core libraries to manage the desktop to be shared between Maui Settings and Cask";
    homepage = "https://github.com/Nitrux/maui-core";
    # Missing license information https://github.com/Nitrux/maui-core/issues/1
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.linux;
  };

}
