{ lib
, buildPythonPackage
, fetchPypi
, mozinfo
}:

buildPythonPackage rec {
  pname = "mozprocess";
  version = "0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f471c45bee9ff14e936c6ee216a6cc4941223659c01fa626bce628001d8485c";
  };

  propagatedBuildInputs = [ mozinfo ];

  meta = {
    description = "Mozilla-authored process handling";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
