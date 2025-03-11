{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "bigarray-compat";
  version = "1.1.0";

  useDune2 = true;

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2JVopggK2JuXWEPu8qn12F1jQIJ9OV89XY1rHtUqLkI=";
  };

  meta = {
    description = "Compatibility library to use Stdlib.Bigarray when possible";
    inherit (src.meta) homepage;
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
