{
  lib,
  fetchFromGitHub,
  openvdb,
}:

openvdb.overrideAttrs (old: rec {
  name = "${old.pname}-${version}";
  version = "11.0.0";
  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    rev = "v${version}";
    sha256 = "sha256-wDDjX0nKZ4/DIbEX33PoxR43dJDj2NF3fm+Egug62GQ=";
  };
  meta = old.meta // {
    license = lib.licenses.mpl20;
  };
})
