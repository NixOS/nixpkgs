{ lib, stdenv
, fetchurl
, autoreconfHook
, gettext
, gnutls
, nettle
, pkg-config
, libiconv
, libxcrypt
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.47.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-YYpYa2E773EKYzxCv92mFmbLsPyKkq1JA2HQvJHFg0E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gettext gnutls nettle libxcrypt ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ApplicationServices ];

  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    export MACOSX_DEPLOYMENT_TARGET=11.0
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://lib.filezilla-project.org/";
    description = "Modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = lib.platforms.unix;
  };
}
