args: with args;

stdenv.mkDerivation {
  name = "akode-2.0.0dev";
  src = svnSrc "akode" "0xkzv386wvh16njjv8z84mg3czp7j7n60lwhwns5fwqhx1s30h5y";
  buildInputs = [ cmake qt openssl gettext cyrus_sasl alsaLib ];
}
