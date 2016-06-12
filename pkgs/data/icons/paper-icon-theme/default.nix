{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "paper-icon-theme";
  version = "2016-06-08";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = package-name;
    rev = "6aa0a2c8d802199d0a9f71579f136bd6476d5d8e";
    sha256 = "07ak1lnvd0gwaclkcvccjbxikh701vfi07gmjp4zcqi6b5crl7f5";
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
