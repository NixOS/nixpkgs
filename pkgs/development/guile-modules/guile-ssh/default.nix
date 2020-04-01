{ stdenv, fetchFromGitHub, guile, libssh
, autoreconfHook, pkg-config, texinfo, which
}:

stdenv.mkDerivation rec {
  pname = "guile-ssh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = pname;
    rev = "v${version}";
    sha256 = "054hd9rzfhb48gc1hw3rphhp0cnnd4bs5qmidy5ygsyvy9ravlad";
  };

  configureFlags = [ "--with-guilesitedir=\${out}/share/guile/site" ];

  postFixup = ''
    for f in $out/share/guile/site/ssh/**.scm; do \
      substituteInPlace $f \
        --replace "libguile-ssh" "$out/lib/libguile-ssh"; \
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo which ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ libssh ];

  meta = with stdenv.lib; {
    description = "Bindings to Libssh for GNU Guile";
    homepage = "https://github.com/artyom-poptsov/guile-ssh";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}

