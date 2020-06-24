{ stdenv, mkFont, fetchzip }:

mkFont rec {
  pname = "ttf-bitstream-vera";
  version = "1.10";

  src = fetchzip {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0p9zdv9kg0fagj5kbrpcwafhpaasacs3qbklknz9qnsprarcs2b7";
  };

  meta = {
  };
}
