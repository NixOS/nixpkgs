{ stdenv, fetchurl, alsaLib, bash, help2man }:

stdenv.mkDerivation rec {
  name = "lirc-0.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "1pd1a7v426hhnj6i6n6xjf2y8yydnw63y53ij40cwvgfrn7r8gsf";
  };

  patches = [
    (fetchurl {
       url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/lirc-0.9.1a-fix-segfaults.patch?h=packages/lirc";
       sha256 = "00ainq7y8yh2r447968jid06cqfb1xirv24xxrkl0gvakrrv9gnh";
    })
  ];

  preBuild = "patchShebangs .";

  buildInputs = [ alsaLib help2man ];

  configureFlags = [
    "--with-driver=devinput"
    "--sysconfdir=$(out)/etc"
    "--enable-sandboxed"
  ];

  makeFlags = [ "m4dir=$(out)/m4" ];

  meta = with stdenv.lib; {
    description = "Allows to receive and send infrared signals";
    homepage = http://www.lirc.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
