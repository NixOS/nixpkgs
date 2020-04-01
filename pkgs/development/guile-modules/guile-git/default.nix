{ stdenv, fetchFromGitHub, fetchFromGitLab, guile, libgit2
, autoreconfHook, pkg-config, texinfo
}:

let
  bytestructures = stdenv.mkDerivation rec {
    pname = "scheme-bytestructures";
    version = "1.0.7";

    src = fetchFromGitHub {
      owner = "TaylanUB";
      repo = pname;
      rev = "v${version}";
      sha256 = "0q0habjiy3h9cigb7q1br9kz6z212dn2ab31f6dgd3rrmsfn5rvb";
    };

    postConfigure = ''
      sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
      sed -i '/godir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
    '';

    nativeBuildInputs = [ autoreconfHook pkg-config ];
    buildInputs = [ guile ];
  };
in stdenv.mkDerivation rec {
  pname = "guile-git";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1s77s70gzfj6h7bglq431kw8l4iknhsfpc0mnvcp4lkhwdcgyn1n";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/godir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ libgit2 bytestructures ];

  meta = with stdenv.lib; {
    description = "Bindings to Libgit2 for GNU Guile";
    homepage = "https://gitlab.com/guile-git/guile-git";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}

