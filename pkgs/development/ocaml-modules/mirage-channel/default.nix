{ lib, fetchurl, buildDunePackage
, cstruct, logs, lwt, mirage-flow
, alcotest, mirage-flow-combinators
}:

buildDunePackage rec {
  pname = "mirage-channel";
  version = "4.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-channel/releases/download/v${version}/mirage-channel-v${version}.tbz";
    sha256 = "0wmb2zhiyp8n78xgcspcsyd19bhcml3kyli2caw3778wc1gyvfpc";
  };

  # Make tests compatible with alcotest 1.4.0
  postPatch = ''
    substituteInPlace test/test_channel.ml --replace 'Fmt.kstrf Alcotest.fail' 'Fmt.kstrf (fun s -> Alcotest.fail s)'
  '';

  propagatedBuildInputs = [ cstruct logs lwt mirage-flow ];

  doCheck = true;
  checkInputs = [ alcotest mirage-flow-combinators ];

  meta = {
    description = "Buffered channels for MirageOS FLOW types";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/mirage-channel";
  };
}
