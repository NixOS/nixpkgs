args: with args;
stdenv.mkDerivation rec {
	name = "libjingle-" + version;
	src = fetchurl {
		url = "mirror://sf/tapioca-voip/${name}.tar.gz";
		sha256 = "1x5l2jwxpkyxvnq0cagq40p6x61v23vxngnnsxr15lyh1zwzk1yj";
	};

  propagatedBuildInputs = [ mediastreamer ];
}
