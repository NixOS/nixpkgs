{ lib
, buildPythonPackage
, fetchPypi
, mozinfo
}:

buildPythonPackage rec {
  pname = "mozprocess";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0fd8367e663d3cac74ee46bffa789667bc8d52f242d81a14522205fa6650cb2";
  };

  propagatedBuildInputs = [ mozinfo ];

  meta = {
    description = "Mozilla-authored process handling";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
