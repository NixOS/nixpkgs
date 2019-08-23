{ stdenv, fetchFromGitHub, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-sound-theme";
  version = "15.10.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-sound-theme";
    rev = version;
    sha256 = "1sw4nrn7q7wk1hpicm05apyc0mihaw42iqm52wb8ib8gm1qiylr9";
  };

  makeFlags = [ "PREFIX=${placeholder ''out''}" ];

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin sound theme";
    homepage = https://github.com/linuxdeepin/deepin-sound-theme;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
