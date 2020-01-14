{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozdevice
}:

buildPythonPackage rec {
  pname = "mozversion";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jczc1yr2yi3mf1qdgpvg9sidp5hf3jplzs4917j65ymvk2zw9na";
  };

  propagatedBuildInputs = [ mozlog mozdevice ];

  meta = {
    description = "Application version information library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
