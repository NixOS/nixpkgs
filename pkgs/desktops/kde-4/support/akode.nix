args: with args;

stdenv.mkDerivation {
  name = "akode-2.0.0dev";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/akode;
	rev = 732646;
	md5 = "6629ffedc42c020d2e8645910a4efdf5";
  };

  buildInputs = [ cmake qt openssl gettext cyrus_sasl alsaLib ];
}
