{ buildPythonPackage
, lib
, fetchurl
, pytest
, u-msgpack-python
, six
}:

buildPythonPackage rec {
  pname = "pytest-expect";
  version = "1.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "36b4462704450798197d090809a05f4e13649d9cba9acdc557ce9517da1fd847";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ u-msgpack-python six ];

  # Tests in neither the archive nor the repo
  doCheck = false;

  meta = {
    description = "py.test plugin to store test expectations and mark tests based on them";
    homepage = https://github.com/gsnedders/pytest-expect;
    license = lib.licenses.mit;
  };
}
