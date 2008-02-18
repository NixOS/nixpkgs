args: with args;

stdenv.mkDerivation {
  name = "akode-2.0.0dev";
  src = svnSrc "akode" "4d72a9aa9d74a8576a8d19edd09f7e1fd3630958b7598586ed8483888f61f975";
  buildInputs = [ cmake qt openssl gettext cyrus_sasl alsaLib ];
}
