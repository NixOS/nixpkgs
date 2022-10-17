{ alcotest-lwt
, buildDunePackage
, dune-site
, fetchzip
, gluten-lwt-unix
, lib
, logs
, lwt_ssl
, magic-mime
, mrmime
, pecu
, psq
, ssl
, uri
}:

buildDunePackage rec {
  pname = "piaf";
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/anmonteiro/piaf/releases/download/${version}/piaf-${version}.tbz";
    sha256 = "0d431kz3bkwlgdamvsv94mzd9631ppcjpv516ii91glzlfdzh5hz";
  };

  postPatch = ''
    substituteInPlace ./vendor/dune --replace "mrmime.prettym" "prettym"
  '';

  propagatedBuildInputs = [
    logs
    magic-mime
    mrmime
    psq
    uri
    gluten-lwt-unix
  ];

  checkInputs = [
    alcotest-lwt
    dune-site
  ];
  # Check fails with OpenSSL 3
  doCheck = false;

  meta = {
    description = "An HTTP library with HTTP/2 support written entirely in OCaml";
    homepage = "https://github.com/anmonteiro/piaf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ anmonteiro ];
  };
}
