{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozdevice
}:

buildPythonPackage rec {
  pname = "mozversion";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9b11e4a46bf7a4a11469ea4589c75f3ba50b34b7801e7edf1a09147af8bf70f";
  };

  propagatedBuildInputs = [ mozlog mozdevice ];

  meta = {
    description = "Application version information library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
