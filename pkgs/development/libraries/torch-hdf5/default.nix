{stdenv, fetchFromGitHub, torch, cmake, hdf5}:
stdenv.mkDerivation rec {
  name = "torch-hdf5-${version}";
  version = "0.0pre2016-07-01";
  buildInputs = [cmake torch hdf5];
  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "torch-hdf5";
    rev = "639bb4e62417ac392bf31a53cdd495d19337642b";
    sha256 = "0x1si2c30d95vmw0xqyq242wghfih3m5i43785vwahlzm7h6n6xz";
  };
  meta = {
    inherit version;
    description = ''HDF5 format support for Torch'';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
