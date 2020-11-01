{ stdenv, fetchurl, makeWrapper, installShellFiles, pkg-config, libiconv }:

stdenv.mkDerivation rec {
  pname = "libdatrie";
  version = "0.2.12";

  src = fetchurl {
    url = "https://github.com/tlwg/libdatrie/releases/download/v${version}/libdatrie-${version}.tar.xz";
    sha256 = "0jdi01pcxv0b24zbjy7zahawsqqqw4mv94f2yy01zh4n796wqba5";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  postInstall = ''
    installManPage man/trietool.1
  '';

  meta = with stdenv.lib;{
    homepage = "https://linux.thai.net/~thep/datrie/datrie.html";
    description = "This is an implementation of double-array structure for representing trie";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
