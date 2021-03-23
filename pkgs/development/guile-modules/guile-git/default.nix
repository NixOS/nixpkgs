{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, texinfo
, guile, guile-bytestructures, libgit2
}:
stdenv.mkDerivation rec {
  pname = "guile-git";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1s77s70gzfj6h7bglq431kw8l4iknhsfpc0mnvcp4lkhwdcgyn1n";
  };

  GUILE_AUTO_COMPILE = 0;

  nativeBuildInputs = [ autoreconfHook pkgconfig texinfo ];
  buildInputs = [ guile libgit2 ];
  propagatedBuildInputs = [ guile-bytestructures ];

  meta = with stdenv.lib; {
    description = "Guile bindings to libgit2";
    homepage = "https://gitlab.com/guile-git/guile-git";
    license = with licenses; [ gpl2Plus lgpl3Plus] ;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.unix;
  };
}
