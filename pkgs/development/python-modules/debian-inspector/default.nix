{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, fetchpatch
, chardet
, attrs
, commoncode
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "debian-inspector";
  version = "0.9.10";

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    sha256 = "fd29a02b925a4de0d7bb00c29bb05f19715a304bc10ef7b9ad06a93893dc3a8c";
  };

  patches = lib.optionals (pythonAtLeast "3.9") [
    # https://github.com/nexB/debian-inspector/pull/15
    # fixes tests on Python 3.9
    (fetchpatch {
      name = "drop-encoding-argument.patch";
      url = "https://github.com/nexB/debian-inspector/commit/ff991cdb788671ca9b81f1602b70a439248fd1aa.patch";
      sha256 = "bm3k7vb9+Rm6+YicQEeDOOUVut8xpDaNavG+t2oLZkI=";
    })
  ];

  dontConfigure = true;

  propagatedBuildInputs = [
    chardet
    attrs
    commoncode
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "debian_inspector"
  ];

  meta = with lib; {
    description = "Utilities to parse Debian package, copyright and control files";
    homepage = "https://github.com/nexB/debian-inspector";
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = teams.determinatesystems.members;
  };
}
