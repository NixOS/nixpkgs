{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, ipython
, matplotlib
, numpy
, pillow
}:

buildPythonPackage rec {
  pname = "mediapy";
  version = "1.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mVhBM+NQEkLYByp/kCPFJCAY26La5CWjcPl6PgclA9A=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ ipython matplotlib numpy pillow ];


  pythonImportsCheck = [ "mediapy" ];

  meta = with lib; {
    description = "Read/write/show images and videos in an IPython notebook";
    homepage = "https://github.com/google/mediapy";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
