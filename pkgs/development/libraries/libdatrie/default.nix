{ lib, stdenv, fetchFromGitHub
, autoreconfHook, autoconf-archive
, installShellFiles, libiconv }:

stdenv.mkDerivation rec {

  pname = "libdatrie";
  version = "2019-12-20";

  outputs = [ "bin" "out" "lib" "dev" ];

  src = fetchFromGitHub {
    owner = "tlwg";
    repo = "libdatrie";
    rev = "d1db08ac1c76f54ba23d63665437473788c999f3";
    sha256 = "03dc363259iyiidrgadzc7i03mmfdj8h78j82vk6z53w6fxq5zxc";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    installShellFiles
  ];

  buildInputs = [ libiconv ];

  preAutoreconf = let
    reports = "https://github.com/tlwg/libdatrie/issues";
  in
  ''
    sed -i -e "/AC_INIT/,+3d" configure.ac
    sed -i "5iAC_INIT(${pname},${version},[${reports}])" configure.ac
  '';

  postInstall = ''
    installManPage man/trietool.1
  '';

  meta = with lib; {
    homepage = "https://linux.thai.net/~thep/datrie/datrie.html";
    description = "This is an implementation of double-array structure for representing trie";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ ];
    pkgConfigModules = [ "datrie-0.2" ];
  };
}
