{ lib
, buildPythonPackage
, fetchPypi
, mozfile
, mozlog
}:

buildPythonPackage rec {
  pname = "mozcrash";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c2d2f32bd6e0ba3644f5d16e427444d8cb51ec1e9baa340a33e10687307f8c4";
  };

  propagatedBuildInputs = [ mozfile mozlog ];

  meta = {
    description = "Minidump stack trace extractor";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
