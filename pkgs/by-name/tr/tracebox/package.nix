{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpcap,
  lua5_1,
  json_c,
  testers,
  tracebox,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tracebox";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "tracebox";
    repo = "tracebox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1KBJ4uXa1XpzEw23IjndZg+aGJXk3PVw8LYKAvxbxCA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libpcap
    lua5_1
    json_c
  ];

  postPatch = ''
    sed -i configure.ac \
      -e 's,$(git describe .*),${finalAttrs.version},'
  '';

  configureFlags = [
    "--with-lua=yes"
    "--with-libpcap=yes"
  ];

  env = {
    CXXFLAGS = "-std=c++14";
    LUA_LIB = "-llua";
    PCAPLIB = "-lpcap";
  };

  enableParallelBuilding = true;

  passthru.tests.version = testers.testVersion {
    package = tracebox;
    command = "tracebox -V";
  };

  meta = {
    homepage = "http://www.tracebox.org/";
    description = "Middlebox detection tool";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ck3d ];
    platforms = lib.platforms.linux;
  };
})
