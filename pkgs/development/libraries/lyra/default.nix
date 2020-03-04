{ stdenv, fetchFromGitHub, installShellFiles, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "lyra";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "bfgroup";
    repo = "lyra";
    rev = version;
    sha256 = "0rpk1hadfcvjps5k307sddv23q73m2918wclfxfi6mj8l7gwkcn9";
  };

  nativeBuildInputs = [ meson ninja ];

  enableParallelBuilding = true;

  postPatch = "sed -i s#/usr#$out#g meson.build";

  postInstall = ''
    mkdir -p $out/include
    cp -R $src/include/* $out/include
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/bfgroup/Lyra";
    description = "A simple to use, composable, command line parser for C++ 11 and beyond";
    platforms = platforms.linux;
    license = licenses.boost;
    maintainers = with maintainers; [ davidtwco ];
  };
}
