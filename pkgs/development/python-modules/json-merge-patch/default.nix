{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "json-merge-patch";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09898b6d427c08754e2a97c709cf2dfd7e28bd10c5683a538914975eab778d39";
  };

  postPatch = ''
    substituteInPlace json_merge_patch/tests.py \
      --replace "import lib as merge" "import json_merge_patch.lib as merge"
  '';

  meta = with lib; {
    description = "JSON Merge Patch library";
    homepage = https://github.com/open-contracting/json-merge-patch;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
