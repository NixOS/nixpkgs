{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c2cf54c9b9af973ad9704d8ba81b225117cab612568cacbfb3fc42958cc20a9";
  };

  # errors with vendored libs
  doCheck = false;

  meta = {
    description = "Pythonic task execution";
    license = lib.licenses.bsd2;
  };
}
