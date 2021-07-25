{ lib, fetchFromGitLab, buildDunePackage, uri, crowbar }:

buildDunePackage rec {
  pname = "json-data-encoding";
  version = "0.8";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "json-data-encoding";
    rev = "v${version}";
    sha256 = "1c6m2qvi9bm6qjxc38p6cia1f66r0rb9xf6b8svlj3jjymvqw889";
  };
  useDune2 = true;

  propagatedBuildInputs = [
    uri
  ];

  checkInputs = [
    crowbar
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/json-data-encoding";
    description = "Type-safe encoding to and decoding from JSON";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
