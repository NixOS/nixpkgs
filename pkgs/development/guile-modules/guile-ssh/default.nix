{ lib
, stdenv
, fetchFromGitHub
, guile
, libssh
, autoreconfHook
, pkg-config
, texinfo
, which
}:

stdenv.mkDerivation rec {
  pname = "guile-ssh";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dcG3Q1K1/CxrMeEUWSZ3Qu57Aesalydg4UjkIqg1NJ0=";
  };

  configureFlags = [ "--with-guilesitedir=\${out}/share/guile/site" ];

  postFixup = ''
    for f in $out/share/guile/site/ssh/**.scm; do \
      substituteInPlace $f \
        --replace "libguile-ssh" "$out/lib/libguile-ssh"; \
    done
  '';

  nativeBuildInputs = [
    autoreconfHook pkg-config texinfo which
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    libssh
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bindings to Libssh for GNU Guile";
    homepage = "https://github.com/artyom-poptsov/guile-ssh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.linux;
  };
}
