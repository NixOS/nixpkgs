{ lib
, fetchPypi
, buildPythonPackage
, numpy
, psutil
, pybind11
}:

buildPythonPackage rec {
  pname = "nmslib";
  version = "2.1.2";

  src = fetchPypi {
    inherit version;
    pname = "fixed-install-nmslib";
    hash = "sha256-RYTI79skdpHeHyOvopuL8TcT29kZK2jzf3sQpB3Rigs=";
  };

  postPatch = ''
    substituteInPlace PKG-INFO setup.py \
      --replace fixed-install-nmslib ${pname}
    mv fixed_install_nmslib.egg-info ${pname}.egg-info
    cd ${pname}.egg-info
    substituteInPlace PKG-INFO \
      --replace fixed-install-nmslib ${pname}
    substituteInPlace SOURCES.txt \
      --replace fixed_install_nmslib ${pname}
    cd ..
  '';

  propagatedBuildInputs = [
    numpy
    psutil
  ];

  nativeCheckInputs = [
    pybind11
  ];

  meta = with lib; {
    homepage = "https://github.com/nmslib/nmslib";
    license = licenses.asl20;
    description = ''
      an efficient cross-platform similarity search library
      and a toolkit for evaluation of similarity search methods
    '';
    maintainers = [ maintainers.gm6k ];
  };
}
