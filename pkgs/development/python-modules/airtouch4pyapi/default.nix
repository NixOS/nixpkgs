{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "airtouch4pyapi";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "LonePurpleWolf";
    repo = pname;
    # https://github.com/LonePurpleWolf/airtouch4pyapi/issues/5
    rev = "34783888846783c058fe79cec16feda45504f701";
    sha256 = "17c7fm72p085pg9msvsfdggbskvm12a6jlb5bw1cndrqsqcrxywx";
  };

  patches = [
    # https://github.com/LonePurpleWolf/airtouch4pyapi/pull/10
    (fetchpatch {
      url = "https://github.com/LonePurpleWolf/airtouch4pyapi/commit/5b5d91fad63495c83422e7a850897946ac95b25d.patch";
      hash = "sha256-tVlCLXuOJSqjbs0jj0iHCIXWZE8wmMV3ChzmE6uq3SM=";
    })
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "airtouch4pyapi" ];

  meta = with lib; {
    description = "Python API for Airtouch 4 controllers";
    homepage = "https://github.com/LonePurpleWolf/airtouch4pyapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
