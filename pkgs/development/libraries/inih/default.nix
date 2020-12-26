{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "r52";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = pname;
    rev = version;
    sha256 = "0lsvm34zabvi1xlximybzvgc58zb90mm3b9babwxlqs05jy871m4";
  };

  nativeBuildInputs = [ meson ninja ];

  mesonFlags = [
    "-Ddefault_library=shared"
    "-Ddistro_install=true"
    "-Dwith_INIReader=true"
  ];

  meta = with stdenv.lib; {
    description = "Simple .INI file parser in C, good for embedded systems";
    homepage = "https://github.com/benhoyt/inih";
    changelog = "https://github.com/benhoyt/inih/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ TredwellGit ];
    platforms = platforms.all;
  };
}
