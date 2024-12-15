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
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Core libraries to manage the desktop to be shared between Maui Settings and Cask";
    homepage = "https://github.com/Nitrux/maui-core";
    # Missing license information https://github.com/Nitrux/maui-core/issues/1
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };

}
