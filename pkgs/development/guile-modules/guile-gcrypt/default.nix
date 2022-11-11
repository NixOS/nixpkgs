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
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "cwebber";
    repo = "guile-gcrypt";
    rev = "v${version}";
    sha256 = "sha256-lAaiKBOdTFWEWsmwKgx0C67ACvtnEKUxti66dslzSVQ=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    libgcrypt
  ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  doCheck = true;

  meta = with lib; {
    description = "Bindings to Libgcrypt for GNU Guile";
    homepage = "https://notabug.org/cwebber/guile-gcrypt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.linux;
  };
}
