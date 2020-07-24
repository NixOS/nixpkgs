{ lib, buildDunePackage, fetchFromGitHub, ocaml
, result, alcotest, cohttp-lwt-unix, odoc, curl }:

buildDunePackage rec {
  pname = "curly";
  version = "unstable-2019-11-14";

  minimumOCamlVersion = "4.02";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "rgrinberg";
    repo   = pname;
    rev    = "33a538c89ef8279d4591454a7f699a4183dde5d0";
    sha256 = "10pxbvf5xrsajaxrccxh2lqhgp3yaf61z9w03rvb2mq44nc2dggz";
  };

  propagatedBuildInputs = [ result ];
  checkInputs = [ alcotest cohttp-lwt-unix ];
  # test dependencies are only available for >= 4.05
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  postPatch = ''
    substituteInPlace src/curly.ml \
      --replace "exe=\"curl\"" "exe=\"${curl}/bin/curl\""
    '';
}

