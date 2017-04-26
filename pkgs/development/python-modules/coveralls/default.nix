{ buildPythonPackage
, lib
, fetchurl
, pythonPackages
}:

let
  pname = "coveralls";
  version = "1.1";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "0238hgdwbvriqxrj22zwh0rbxnhh9c6hh75i39ll631vq62h65il";
  };

  buildInputs = with pythonPackages; [
    coverage
    docopt
    requests
  ];
  propagatedBuildInputs = [];

  # Tests in neither the archive nor the repo
  doCheck = false;

  meta = {
    description = "py.test plugin to store test expectations and mark tests based on them";
    homepage = https://github.com/gsnedders/pytest-expect;
    license = lib.licenses.mit;
  };
}


