{ lib
, buildDunePackage
, fetchFromGitHub

, ppx_fields_conv
, ppx_sexp_conv

, cohttp-lwt
, ezjsonm
, hmap
}:

buildDunePackage rec {
	pname = "opium_kernel";
  version = "0.17.1";

  minimumOCamlVersion = "4.04.1";
  
	src = fetchFromGitHub {
		owner = "rgrinberg";
		repo = "opium";
		rev = "v${version}";
		sha256 = "03xzh0ik6k3c0yn1w1avph667vdagwclzimwwrlf9qdxnzxvcnp3";
	};

  doCheck = true;

	buildInputs = [
    ppx_sexp_conv ppx_fields_conv
  ];

	propagatedBuildInputs = [
    hmap cohttp-lwt ezjsonm
  ];

  meta = {
		description = "Sinatra like web toolkit for OCaml based on cohttp & lwt";
    homepage = "https://github.com/rgrinberg/opium";
		license = lib.licenses.mit;
		maintainers = [ lib.maintainers.pmahoney ];
  };
}
