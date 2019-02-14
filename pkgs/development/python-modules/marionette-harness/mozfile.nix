{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mozfile";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22a43f3bc320c3bda27e54b293c23a51660f4a00ec6959ab70ca6136d702f578";
  };

  propagatedBuildInputs = [ ];

  # mozhttpd -> moznetwork -> mozinfo -> mozfile
  doCheck = false;

  meta = {
    description = "File utilities for Mozilla testing";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
