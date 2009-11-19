{ stdenv, fetchurl, mediastreamer }:

stdenv.mkDerivation rec {
  name = "libjingle-0.3.11";
  
  src = fetchurl {
    url = "mirror://sourceforge/tapioca-voip/${name}.tar.gz";
    sha256 = "1x5l2jwxpkyxvnq0cagq40p6x61v23vxngnnsxr15lyh1zwzk1yj";
  };

  propagatedBuildInputs = [ mediastreamer ];
}
