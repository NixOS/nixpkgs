{ lib
, buildPythonPackage
, fetchPypi
, h5py
, numpy
, scipy
, pandas
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "hdmf";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97327af064d398f97b1ceaaee02cea872654dccf6dd2dce106dc2f3ec85bed38";
  };

  propagatedBuildInputs = [
    h5py
    numpy
    scipy
    pandas
    ruamel_yaml
  ];

  meta = with lib; {
    description = "A package for standardizing hierarchical object data";
    homepage = "https://github.com/hdmf-dev/hdmf";
    license = licenses.bsd3;
    maintainers = [ maintainers.tbenst ];
  };
}