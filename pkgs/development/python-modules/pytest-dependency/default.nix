{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-dependency";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wqiSkGGSZj+FAwpquRME5QjlRs3f5VfWktYexXodlGs=";
  };

  patches = [
    # Fix build with pytest >= 6.2.0, https://github.com/RKrahl/pytest-dependency/pull/51
    (fetchpatch {
      url = "https://github.com/RKrahl/pytest-dependency/commit/0930889a13e2b9baa7617f05dc9b55abede5209d.patch";
      sha256 = "sha256-xRreoIz8+yW0mAUb4FvKVlPjALzMAZDmdpbmDKRISE0=";
    })
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/RKrahl/pytest-dependency";
    description = "Manage dependencies of tests";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
