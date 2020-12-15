{ stdenv, fetchurl, installShellFiles, lua }:

stdenv.mkDerivation rec {
  pname = "fennel";
  version = "0.7.0";

  src = fetchurl {
    url = "https://git.sr.ht/~technomancy/fennel/archive/${version}.tar.gz";
    sha256 = "03wg0rrp5abra012xkyjb1nlij27w824f1bayd090bzph7bdds5j";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ lua ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    installManPage fennel.1
  '';

  meta = with stdenv.lib; {
    description = "A Lua Lisp language";
    homepage = "https://fennel-lang.org/";
    license = licenses.mit;
    platforms = lua.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
