{ lib, stdenv, fetchFromSourcehut, installShellFiles, lua }:

stdenv.mkDerivation rec {
  pname = "fennel";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "sha256-HhxFTWC1gBY76pQzhn6EdgYHpYQr9zkUox0r4YC7mTQ=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ lua ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    installManPage fennel.1
  '';

  meta = with lib; {
    description = "A Lua Lisp language";
    homepage = "https://fennel-lang.org/";
    license = licenses.mit;
    platforms = lua.meta.platforms;
    maintainers = [ maintainers.maaslalani ];
  };
}
