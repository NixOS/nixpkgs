{ lib, buildPythonPackage, fetchFromGitHub, GitPython
, libpcap, meson, ninja, pillow, pkg-config, pygobject3, SDL2
, alsa-lib, soundtouch, openal
}:

let
  desmume = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "desmume";
    rev = "8e7af8ada883b7e91344985236f7c7c04ee795d7";
    sha256 = "0svmv2rch9q347gbpbws4agymas8n014gh1ssaf91wx7jwn53842";
  };
in
buildPythonPackage rec {
  pname = "py-desmume";
  version = "0.0.3.post2";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "1chsg70k8kqnlasn88b04ww3yl0lay1bjxvz6lhp6s2cvsxv03x1";
  };

  postPatch = ''
    cp -R --no-preserve=mode ${desmume} __build_desmume
  '';

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
