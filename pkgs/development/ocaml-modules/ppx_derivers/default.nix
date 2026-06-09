{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_derivers";
  version = "1.2.1";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "diml";
    repo = "ppx_derivers";
    rev = finalAttrs.version;
    sha256 = "0yqvqw58hbx1a61wcpbnl9j30n495k23qmyy2xwczqs63mn2nkpn";
  };

  meta = {
    description = "Shared [@@deriving] plugin registry";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (finalAttrs.src.meta) homepage;
  };
})
