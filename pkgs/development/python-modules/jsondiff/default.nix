{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BM+uvUpeVziUirYVcQ3D7pjvvfhRJV/Tl3xMLuWecxI=";
  };

  postPatch = ''
    sed -e "/'jsondiff=jsondiff.cli:main_deprecated',/d" -i setup.py
  '';

  # No tests
  doCheck = false;

  meta = {
    description = "Diff JSON and JSON-like structures in Python";
    homepage = "https://github.com/ZoomerAnalytics/jsondiff";
    license = lib.licenses.mit;
  };
}
