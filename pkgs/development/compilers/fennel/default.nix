{ lib, stdenv, fetchFromSourcehut, installShellFiles, lua }:

stdenv.mkDerivation rec {
  pname = "fennel";
  version = "0.9.2";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "1kpm3lzxzwkhxm4ghpbx8iw0ni7gb73y68lsc3ll2rcx0fwv9303";
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
