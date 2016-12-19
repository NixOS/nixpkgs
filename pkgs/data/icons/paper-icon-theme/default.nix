{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "paper-icon-theme";
  version = "2016-11-05";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "2a1f25a47fe8fb92e9d4db5537bbddb539586602";
    sha256 = "0v956wrfraaj5qznz86q7s3zi55xd3gxmg7pzcfsw2ghgfv13swd";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  meta = with stdenv.lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = http://snwh.org/paper;
    license = with licenses; [ cc-by-sa-40 lgpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
