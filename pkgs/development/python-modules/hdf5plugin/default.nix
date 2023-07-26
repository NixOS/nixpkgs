{ lib
, buildPythonPackage
, fetchFromGitHub
, h5py
}:

buildPythonPackage rec {
  pname = "hdf5plugin";
  version = "4.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "silx-kit";
    repo = "hdf5plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-0emCZ+r5dCRBT2xaNsgYskcGcLF/9Jf6K7FFi/PA+60=";
  };

  propagatedBuildInputs = [
    h5py
  ];

  checkPhase = ''
    python test/test.py
  '';
  pythonImportsCheck = [
    "hdf5plugin"
  ];

  preBuild = ''
    mkdir src/hdf5plugin/plugins
  '';

  meta = with lib; {
    description = "Additional compression filters for h5py";
    longDescription = ''
      hdf5plugin provides HDF5 compression filters and makes them usable from h5py.
      Supported encodings: Blosc, Blosc2, BitShuffle, BZip2, FciDecomp, LZ4, SZ, SZ3, Zfp, ZStd
    '';
    homepage = "http://www.silx.org/doc/hdf5plugin/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };

}
