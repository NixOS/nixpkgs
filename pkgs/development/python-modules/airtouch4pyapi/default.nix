{ lib
, buildPythonPackage
, fetchFromGitHub
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
