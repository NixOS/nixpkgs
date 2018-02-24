{ stdenv, fetchFromGitHub, autoreconfHook, faba-icon-theme, gtk3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "moka-icon-theme";
  version = "5.3.6";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    rev = "v${version}";
    sha256 = "17f8k8z8xvib4hkxq0cw9j7bhdpqpv5frrkyc4sbyildcbavzzbr";
  };

  nativeBuildInputs = [ autoreconfHook faba-icon-theme gtk3 ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  postFixup = "gtk-update-icon-cache $out/share/icons/Moka";

  meta = with stdenv.lib; {
    description = "An icon theme designed with a minimal flat style using simple geometry and bright colours";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
