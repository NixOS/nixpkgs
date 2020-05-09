{ stdenv, fetchFromGitHub, guile
, autoreconfHook, pkg-config
}:

stdenv.mkDerivation rec {
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

  meta = with stdenv.lib; {
    description = "Structured access to bytevector contents";
    homepage = "https://github.com/TaylanUB/scheme-bytestructures";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}

