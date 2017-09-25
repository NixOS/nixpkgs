{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozfile
, mozlog
}:

buildPythonPackage rec {
  pname = "mozcrash";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02101v6v2jqlv6cbrmmggj12asz9vz6m50b6mk9mq17b1dr1zik3";
  };

  propagatedBuildInputs = [ mozfile mozlog ];

  meta = {
    description = "Minidump stack trace extractor";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
