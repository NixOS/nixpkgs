{ lib
, stdenv
, fetchFromGitLab
, guile
, libgit2
, scheme-bytestructures
, autoreconfHook
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-git";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "guile-git";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s77s70gzfj6h7bglq431kw8l4iknhsfpc0mnvcp4lkhwdcgyn1n";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/godir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [
    autoreconfHook pkg-config texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    libgit2 scheme-bytestructures
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bindings to Libgit2 for GNU Guile";
    homepage = "https://gitlab.com/guile-git/guile-git";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.linux;
  };
}

