{ lib
, buildPythonPackage
, fetchPypi
, chardet
, h5py
, numpy
, scipy
, pandas
, ruamel_yaml
, six
, unittest2
}:

buildPythonPackage rec {
  pname = "hdmf";
  version = "1.3.3";
  # pynwb depends on 1.3.3. 1.4 does not work

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r3wj5pifhzfa773lnkl7garc18svfvpk5y5p0d0ww4xc2hab1k1";
  };

  checkInputs = [ unittest2 ];

  propagatedBuildInputs = [
    chardet
    h5py
    numpy
    scipy
    pandas
    ruamel_yaml
    six
  ];

  meta = with lib; {
    description = "A package for standardizing hierarchical object data";
    homepage = "https://github.com/hdmf-dev/hdmf";
    license = licenses.bsd3-lbnl;
    maintainers = [ maintainers.tbenst ];
  };
}