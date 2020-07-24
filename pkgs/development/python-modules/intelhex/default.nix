{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "intelhex";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ckqjbxd8gwcg98gfzpn4vq1qxzfvq3rdbrr1hikj1nmw08qb780";
  };

  patches = [
    # patch the tests to check for the correct version string (2.2.1)
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/bialix/intelhex/pull/26.patch";
      sha256 = "1f3f2cyf9ipb9zdifmjs8rqhg028dhy91vabxxn3l7br657s8r2l";
    })
  ];

  meta = {
    homepage = "https://github.com/bialix/intelhex";
    description = "Python library for Intel HEX files manipulations";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
