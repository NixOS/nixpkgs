{ buildPythonPackage
, lib
, fetchurl
, pythonPackages
}:

let
  pname = "pytest-httpbin";
  version = "0.2.3";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "1y0v2v7xpzpyd4djwp7ad8ifnlxp8r1y6dfbxg5ckzvllkgridn5";
  };

  buildInputs = with pythonPackages; [ pytest httpbin ];
  propagatedBuildInputs = [];

  # Tests in neither the archive nor the repo
  doCheck = false;

  meta = {
    description = "py.test plugin to store test expectations and mark tests based on them";
    homepage = https://github.com/gsnedders/pytest-expect;
    license = lib.licenses.mit;
  };
}

