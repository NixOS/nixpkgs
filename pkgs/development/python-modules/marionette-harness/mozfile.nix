{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mozfile";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mz941np62mg0zncy74d8fbq9fafsxjsxlwdsydl92badhrhzc6k";
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
