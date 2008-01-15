args: with args;

stdenv.mkDerivation {
  name = "acl-2.2.45";

  builder = ./builder.sh;
  src = 
	fetchurl {
		url = ftp://oss.sgi.com/projects/xfs/cmd_tars/acl_2.2.45-1.tar.gz;
		sha256 = "1bb2k5br494yk863w27k1h8gkdkq4kzakvajhj844hl1cixhhf1a";
	};
  buildInputs = [autoconf libtool gettext attr];
  patches = [ ./acl-2.2.45-patch ];
}
