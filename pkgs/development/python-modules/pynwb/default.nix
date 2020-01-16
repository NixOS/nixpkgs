{ lib
, buildPythonPackage
, fetchPypi
, chardet
, h5py
, hdmf
, numpy
, pandas
, python-dateutil
, ruamel_yaml
, six
, unittest2
}:

buildPythonPackage rec {
  pname = "pynwb";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35955986ab44849776809bcbb65880d5baed44aebaff5f0eb85eabc7b1c3a1f0";
  };


  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # hdmf (==1.3.3)
  patchPhase = ''
    substituteInPlace requirements.txt \
      --replace "chardet==3.0.4" "chardet" \
      --replace "h5py==2.10.0" "h5py" \
      --replace "hdmf==1.3.3" "hdmf" \
      --replace "numpy==1.17.2" "numpy" \
      --replace "pandas==0.25.1" "pandas" \
      --replace "python-dateutil==2.8.0" "python-dateutil" \
      --replace "ruamel.yaml==0.16.5" "ruamel.yaml" \
      --replace "six==1.12.0" "six"
    rm tests/build_fake_data.py
    rm tests/build_fake_extension.py
  '';

  # doCheck = false;

  checkInputs = [ unittest2 ];

  propagatedBuildInputs = [
    chardet
    h5py
    hdmf
    numpy
    pandas
    python-dateutil
    ruamel_yaml
    six
  ];

  meta = with lib; {
    description = "Package for working with Neurodata stored in the NWB format";
    homepage = https://github.com/NeurodataWithoutBorders/pynwb;
    license = licenses.bsd3-lbnl;
    maintainers = [ maintainers.tbenst ];
  };
}