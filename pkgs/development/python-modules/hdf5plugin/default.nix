{ lib
, buildPythonPackage
, fetchFromGitHub
, h5py
}:

buildPythonPackage rec {
  pname = "hdf5plugin";
<<<<<<< HEAD
  version = "4.1.3";
=======
  version = "4.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "silx-kit";
    repo = "hdf5plugin";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-0emCZ+r5dCRBT2xaNsgYskcGcLF/9Jf6K7FFi/PA+60=";
=======
    hash = "sha256-w3jgIKfJPlu8F2rJXATmbHKyabp3PQLVmCYj3RsYL3c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ pbsds ];
=======
    maintainers = with maintainers; [ bhipple ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

}
