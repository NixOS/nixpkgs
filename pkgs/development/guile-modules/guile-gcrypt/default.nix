{ lib
, stdenv
, fetchFromGitea
, guile
, libgcrypt
, autoreconfHook
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-gcrypt";
  version = "0.4.0";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "cwebber";
    repo = "guile-gcrypt";
    rev = "v${version}";
    hash = "sha256-vbm31EsOJiMeTs2tu5KPXckxPcAQbi3/PGJ5EHCC5VQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook guile libgcrypt pkg-config texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    libgcrypt
  ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  doCheck = true;

  # In procedure bytevector-u8-ref: Argument 2 out of range
  dontStrip = stdenv.isDarwin;

  meta = with lib; {
    description = "Bindings to Libgcrypt for GNU Guile";
    homepage = "https://notabug.org/cwebber/guile-gcrypt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = guile.meta.platforms;
  };
}
