{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "lyra";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "bfgroup";
    repo = "lyra";
    rev = version;
    sha256 = "sha256-tS2SPLiKaL8C35AmOXyJPstFUfynkE/A53rurqiySbI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  postPatch = "sed -i s#/usr#$out#g meson.build";

  postInstall = ''
    mkdir -p $out/include
    cp -R $src/include/* $out/include
  '';

  meta = with lib; {
    homepage = "https://github.com/bfgroup/Lyra";
    description = "A simple to use, composable, command line parser for C++ 11 and beyond";
    platforms = platforms.unix;
    license = licenses.boost;
    maintainers = with maintainers; [ davidtwco ];
  };
}
