{ lib, stdenv, fetchFromSourcehut, installShellFiles, lua }:

stdenv.mkDerivation rec {
  pname = "fennel";
  version = "1.2.0";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "sha256-TXmqvhT7Ab+S0UdLgl4xWrVvE//eCbu6qNnoxB7smE4=";
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
