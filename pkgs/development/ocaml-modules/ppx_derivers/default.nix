{ stdenv, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
	pname = "ppx_derivers";
	version = "1.2";

  minimumOCamlVersion = "4.02";

	src = fetchFromGitHub {
		owner = "diml";
		repo = pname;
		rev = version;
		sha256 = "0bnhihl1w31as5w2czly1v3d6pbir9inmgsjg2cj6aaj9v1dzd85";
	};

	meta = {
		description = "Shared [@@deriving] plugin registry";
		license = stdenv.lib.licenses.bsd3;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
