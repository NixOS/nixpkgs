{ stdenv, fetchFromGitHub, autoreconfHook, elementary-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "faba-icon-theme";
  version = "2016-06-02";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = package-name;
    rev = "e50649d0171fd8cce42404c7c5002d77710ffcfc";
    sha256 = "1fn969a6l58asnl9181c2z1fsj4dybl2mgbcpwig20bri6q7yz20";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ elementary-icon-theme ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  meta = with stdenv.lib; {
    description = "A sexy and modern icon theme with Tango influences";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
