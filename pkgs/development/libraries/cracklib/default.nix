{ stdenv, fetchurl, zlib, gettext }:

# TODO: wordlist? https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-words-2.9.7.gz is a start!
stdenv.mkDerivation rec {
  pname = "cracklib";
  version = "2.9.7";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "1rimpjsdnmw8f5b7k558cic41p2qy2n2yrlqp5vh7mp4162hk0py";
  };

  buildInputs = [ zlib gettext ];

  postPatch = ''
    chmod +x util/cracklib-format
    patchShebangs util
  '';

  postInstall = ''
    make dict
  '';
  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with stdenv.lib; {
    homepage    = https://github.com/cracklib/cracklib;
    description = "A library for checking the strength of passwords";
    license = licenses.lgpl21; # Different license for the wordlist: http://www.openwall.com/wordlists
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
