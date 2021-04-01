{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-27291.patch";
      url = "https://github.com/pygments/pygments/commit/2e7e8c4a7b318f4032493773732754e418279a14.patch";
      sha256 = "0ap7jgkmvkkzijabsgnfrwl376cjsxa4jmzvqysrkwpjq3q4rxpa";
      excludes = ["CHANGES"];
    })
  ];

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;

  meta = {
    homepage = "https://pygments.org/";
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
