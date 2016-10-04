{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "idnkit-1.0";

  src = fetchurl {
    url = "http://www.nic.ad.jp/ja/idn/idnkit/download/sources/${name}-src.tar.gz";
    sha256 = "1z4i6fmyv67sflmjg763ymcxrcv84rbj1kv15im0s655h775zk8n";
  };

  buildInputs = [ libiconv ];

  meta = with stdenv.lib; {
    homepage = https://www.nic.ad.jp/ja/idn/idnkit;
    description = "Provides functionalities about i18n domain name processing";
    license = "idnkit-2 license";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
