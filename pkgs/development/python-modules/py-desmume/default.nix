{ lib, buildPythonPackage, fetchFromGitHub, GitPython
, libpcap, meson, ninja, pillow, pkg-config, pygobject3, SDL2
, alsa-lib, soundtouch, openal
}:

buildPythonPackage rec {
  pname = "py-desmume";
  version = "0.0.4.post2";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "sha256-a819+K/Ovnz53ViDKpUGGjeblWvrAO5ozt/tizdLKCY=";
    fetchSubmodules = true;
  };

  buildInputs = [ GitPython libpcap SDL2 alsa-lib soundtouch openal ];
  nativeBuildInputs = [ meson ninja pkg-config ];
  propagatedBuildInputs = [ pillow pygobject3 ];

  hardeningDisable = [ "format" ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "desmume" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/py-desmume";
    description = "Python library to interface with DeSmuME, the Nintendo DS emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
