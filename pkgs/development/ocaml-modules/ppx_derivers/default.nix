{ stdenv, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
	pname = "ppx_derivers";
	version = "1.2.1";

  minimumOCamlVersion = "4.02";

	src = fetchFromGitHub {
		owner = "diml";
		repo = pname;
		rev = version;
		sha256 = "0yqvqw58hbx1a61wcpbnl9j30n495k23qmyy2xwczqs63mn2nkpn";
	};

	meta = {
		description = "Shared [@@deriving] plugin registry";
		license = stdenv.lib.licenses.bsd3;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
