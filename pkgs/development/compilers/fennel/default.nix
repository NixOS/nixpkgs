{ lib, stdenv, fetchFromSourcehut, installShellFiles, lua }:

stdenv.mkDerivation rec {
  pname = "fennel";
  version = "0.10.0";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "sha256-/xCnaDNZJTBGxIgjPUVeEyMVeRWg8RCNuo5nPpLrJXY=";
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
